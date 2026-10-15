module ApplicationHelper
  # Anchos que se generan para cada foto. El celular baja la chica; nunca el
  # original de cámara, que puede pesar 6 MB (CLAUDE.md).
  VARIANT_WIDTHS = { sm: 320, md: 640, lg: 960 }.freeze
  WIDE_VARIANT_WIDTHS = { sm: 480, md: 900, lg: 1600 }.freeze

  # Nombre científico: serif itálica, en todo el sitio (CLAUDE.md).
  #
  #   <%= sci "Grammostola vachoni" %>
  #   <%= sci do %>Acanthogonatus<% end %>
  def sci(name = nil, &block)
    tag.span(name || capture(&block), class: "sci")
  end

  # Atributos para abrir un link en una pestaña nueva.
  #
  # El grupo pidió que TODO el contenido abra en pestaña nueva, no solo lo
  # externo. Quedan afuera a propósito, porque ahí la pestaña nueva estorba en
  # vez de ayudar:
  #   - la barra de navegación, el logo y el menú de celular
  #   - el switch de idioma (abrir la otra versión aparte no tiene sentido)
  #   - el "saltar al contenido" del layout, que es un ancla de la misma página
  #   - el "volver a novedades", que es navegación hacia atrás
  #   - los `mailto:`, que en varios navegadores dejan una pestaña vacía colgada
  #
  # `rel="noopener"` siempre: sin eso la página destino puede manipular
  # `window.opener`.
  def new_tab = { target: "_blank", rel: "noopener" }

  # Taxones que aparecen en los textos del grupo. La lista es explícita a
  # propósito: detectar nombres científicos por forma (mayúscula inicial, latín)
  # da falsos positivos con apellidos y topónimos, que abundan en estas bios.
  #
  # Si el grupo empieza a trabajar con otro género, se agrega acá.
  TAXA = %w[
    Mygalomorphae Theraphosidae Migidae Nemesiidae Pycnothelidae
    Acanthogonatus Catumiri Euathlus Grammostola Phrixotrichus Plesiopelma
  ].freeze

  TAXA_PATTERN = /\b(#{Regexp.union(TAXA).source})\b/

  # Itálica automática para los taxones dentro de un texto plano cargado desde
  # el panel (bios del equipo, descripciones). Fiorela pega desde Word y no va a
  # marcar los nombres a mano, así que no puede depender de ella.
  def sci_text(text)
    return if text.blank?

    safe_join(
      text.to_s.split(TAXA_PATTERN).map.with_index do |fragment, index|
        # split con grupo de captura intercala: texto, taxón, texto, taxón...
        index.odd? ? sci(fragment) : fragment
      end
    )
  end

  # Cuerpo de una novedad, que viene de Action Text. Hace dos cosas en un solo
  # parseo:
  #
  #   1. Itálica los taxones, recorriendo solo los nodos de texto para no tocar
  #      atributos ni romper las figuras de las imágenes embebidas.
  #   2. Abre los links en pestaña nueva, como el resto del sitio.
  #
  # El punto 2 no se puede resolver al guardar: el sanitizador de Action Text
  # descarta el atributo `target` de los `<a>`, así que un link escrito con
  # target="_blank" (desde Trix o desde un seed) lo pierde en la base. La única
  # forma de sostenerlo es agregarlo al renderizar.
  #
  # El cuerpo es HTML del editor del propio grupo, no entrada anónima, y Action
  # Text ya lo sanitizó al guardarlo.
  def rich_body(html)
    return if html.blank?

    fragment = Nokogiri::HTML5.fragment(html.to_s)

    fragment.xpath(".//text()").each do |node|
      next unless node.content.match?(TAXA_PATTERN)
      # Un taxón ya marcado a mano desde el editor no se vuelve a envolver.
      next if node.ancestors.any? { |a| a["class"].to_s.split.include?("sci") }

      node.replace(sci_text(node.content).to_s)
    end

    fragment.css("a[href]").each do |link|
      # Un ancla a la misma página no abre pestaña.
      next if link["href"].start_with?("#")

      link["target"] = "_blank"
      link["rel"] = "noopener"
    end

    fragment.to_html.html_safe
  end

  # <img> con srcset a partir de las variantes de Active Storage.
  #
  # `sizes` describe cuánto ancho ocupa la imagen en pantalla, para que el
  # navegador elija la variante antes de conocer el layout.
  # `attachment` puede ser un has_one_attached (que responde a `attached?`) o
  # un adjunto suelto de un has_many_attached (que no).
  def responsive_image_tag(attachment, sizes:, widths: VARIANT_WIDTHS, **options)
    return if attachment.nil?
    return if attachment.respond_to?(:attached?) && !attachment.attached?

    # Las URLs de las variantes se arman a mano: `image_tag` no sabe resolver
    # un objeto de Active Storage dentro de `srcset`, solo en `src`.
    srcset = widths.map { |name, width| "#{url_for(attachment.variant(name))} #{width}w" }.join(", ")

    image_tag url_for(attachment.variant(widths.keys.last)),
              srcset: srcset,
              sizes: sizes,
              loading: options.delete(:loading) || "lazy",
              decoding: "async",
              **options
  end

  # Hueco para una foto que el grupo todavía no mandó. Se ve que falta, pero
  # no rompe el layout (CLAUDE.md: no inventar contenido).
  def photo_placeholder(label = nil, css_class: nil, **options)
    tag.div(class: [ "relative flex items-center justify-center bg-paper-2 border border-hairline", css_class ], **options) do
      tag.span(label || t("comun.foto_pendiente"),
               class: "font-mono text-[9px] tracking-[0.16em] uppercase text-ink-soft/70 text-center px-2")
    end
  end

  # Link del menú: resaltado fuerte en hover, fondo sólido (CLAUDE.md).
  def nav_link_to(label, path, **options)
    active = current_page?(path)

    link_to label, path,
            class: [
              "block px-3 py-2 text-[12.5px] rounded-[2px] transition-colors",
              ("bg-structure text-paper" if active),
              ("text-ink-soft hover:bg-structure hover:text-paper" unless active)
            ],
            **options
  end

  # Misma página, en el otro idioma. El español va sin prefijo.
  def locale_switch_url(locale)
    locale = locale.to_sym
    url_for(locale: (locale == I18n.default_locale ? nil : locale), only_path: true)
  rescue ActionController::UrlGenerationError
    # Alguna ruta sin equivalente en el otro idioma: al menos no rompas la página.
    root_path(locale: (locale == I18n.default_locale ? nil : locale))
  end

  # Logo del grupo, si ya lo mandaron. Mientras tanto, el menú dibuja un
  # placeholder (CLAUDE.md: el logo sigue pendiente del cliente).
  def site_logo
    Rails.root.glob("app/assets/images/logo.{svg,png,jpg,jpeg,webp}")
         .first
         &.basename
         &.to_s
  end

  # Fecha larga en el idioma actual: "12 de marzo de 2025".
  def long_date(date)
    return if date.blank?

    l(date.to_date, format: :long)
  end

  # Etiqueta traducida de un enum ("divulgacion" -> "Divulgación").
  def enum_label(record, attribute)
    value = record.public_send(attribute)
    return if value.blank?

    t("enums.#{record.model_name.i18n_key}.#{attribute}.#{value}", default: value.humanize)
  end
end
