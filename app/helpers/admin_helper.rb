module AdminHelper
  # Campo del panel con su etiqueta, una ayuda opcional y el error de
  # validación justo abajo. Lo carga gente no técnica: cada campo explica qué
  # va y qué pasa si se deja vacío (CLAUDE.md).
  #
  #   <%= admin_field form, :excerpt, hint: "Una o dos oraciones." do %>
  #     <%= form.text_area :excerpt, class: "admin-input" %>
  #   <% end %>
  def admin_field(form, attribute, label: nil, hint: nil, &block)
    errors = form.object.errors[attribute]

    tag.div(class: "admin-field") do
      safe_join([
        form.label(attribute, label, class: "admin-label"),
        (tag.p(hint, class: "admin-hint") if hint),
        capture(&block),
        (tag.p("#{form.object.class.human_attribute_name(attribute)} #{errors.to_sentence}", class: "admin-error") if errors.any?)
      ].compact)
    end
  end

  STATUS_LABELS = {
    borrador:   "Borrador",
    programada: "Programada",
    publicada:  "Publicada"
  }.freeze

  # Etiqueta del estado de una novedad, con un color por estado.
  def post_status_badge(post)
    css = case post.status
    when :publicada  then "bg-structure text-paper"
    when :programada then "bg-ocre text-ink"
    else                  "border border-hairline text-ink-soft"
    end

    tag.span(STATUS_LABELS.fetch(post.status),
             class: [ "inline-block px-2 py-0.5 font-mono text-[10px] uppercase tracking-[0.1em]", css ])
  end
end
