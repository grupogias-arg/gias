# =============================================================================
# NOVEDADES — contenido REAL del grupo
# =============================================================================
#
# Sale de los .docx de drive/NEWS/, una carpeta por nota. Sin prefijo
# "[EJEMPLO]": el texto es el que escribió el grupo, no relleno.
#
# Las fotos van EMBEBIDAS en el cuerpo de Action Text, no adjuntas: `Post` no
# tiene imagen de portada y `documents` es para los PDF del pie (CLAUDE.md).
#
# `published_at` es APROXIMADO. El grupo no pasó fechas de publicación, así que
# se deduce del EXIF de las fotos de cada nota, que marca cuándo pasó el hecho.
# Fiorela las puede corregir desde el panel; lo único que define es el orden.
#
# Falta la nota de "Semana de la Ciencia" que menciona el doc "Ideas": no
# mandaron texto.
# =============================================================================

NEWS_ROOT = Rails.root.join("drive/NEWS")

news_index = SeedSupport.drive_index(NEWS_ROOT)

posts = [
  {
    slug: "premio-divulgacion-cerzos-2026",
    kind: "premio",
    carpeta: "Premio Divulgación - Iru",
    # EXIF de DSC09485/DSC09498: 22-04-2026, el día de la jornada.
    published_at: Time.zone.local(2026, 4, 22, 12),
    title: "Premio al Mejor Artículo de Divulgación CERZOS 2026",
    excerpt: "El artículo “Hilos de curiosidad: la doble arquitectura de una tarántula serrana”, de Micaela Millenpeier, fue distinguido con el Premio al Mejor Artículo de Divulgación CERZOS 2026.",
    parrafos: [
      "El artículo de divulgación “Hilos de curiosidad: la doble arquitectura de una tarántula serrana”, de la Lic. Micaela Millenpeier, integrante del Grupo de Investigaciones Aracnológicas del Sur (GIAS), fue publicado en el Boletín del CERZOS y distinguido con el Premio al Mejor Artículo de Divulgación CERZOS 2026.",
      "El trabajo nace del estudio de la biología reproductiva de una pequeña tarántula del género Catumiri, que habita en el Sistema Serrano de Tandilia, en la provincia de Buenos Aires. Durante el seguimiento de las hembras y de su comportamiento reproductivo, se registró una estrategia particular vinculada a la construcción y protección de los sacos de huevos, una observación que abrió nuevos interrogantes sobre la biología de la especie.",
      "Con esta observación como punto de partida, el artículo invita a recorrer el proceso de descubrimiento, desde las primeras interpretaciones hasta las nuevas preguntas que surgieron a partir de la evidencia. El relato acerca al público algunos aspectos poco conocidos de la biología de las arañas y, al mismo tiempo, muestra que hacer ciencia también implica observar con atención, cuestionar nuestras propias interpretaciones y seguir preguntándonos qué hay detrás de aquello que todavía no comprendemos.",
      # El original decía "conocer un poco maps sobre": errata evidente por "más".
      "El reconocimiento como Mejor Artículo de Divulgación CERZOS 2026 destaca el valor de comunicar investigaciones que permiten conocer un poco más sobre la diversidad y la biología de organismos que muchas veces pasan desapercibidos, y de compartir con públicos más amplios no solo los resultados de la investigación, sino también la curiosidad que impulsa el trabajo científico."
    ]
  },
  {
    slug: "pasantia-rio-claro-unesp-brasil",
    kind: "equipo",
    carpeta: "Pasantía Brasil Maite",
    # EXIF de IMG_20260828: 28-08-2026, sobre el final de la pasantía.
    published_at: Time.zone.local(2026, 8, 28, 12),
    title: "Pasantía de investigación en el Laboratorio de Aracnología de Rio Claro (UNESP), Brasil",
    excerpt: "Maite Allegue realizó una pasantía de un mes en la Universidade Estadual Paulista, donde se capacitó en técnicas de morfometría aplicadas al estudio de arañas migalomorfas.",
    parrafos: [
      "En el marco del programa de movilidad de la Asociación Universitaria Iberoamericana de Postgrado (AUIP), Maite Allegue, estudiante de doctorado e integrante del Grupo de Investigaciones Aracnológicas del Sur (GIAS), realizó una pasantía de investigación de un mes en la Universidade Estadual Paulista (UNESP), en Rio Claro, Brasil. Durante su estadía, fue recibida por el grupo de Aracnología de Río Claro, a cargo del investigador José Paulo Guadanucci.",
      "Durante la pasantía, Maite se capacitó en distintas técnicas de morfometría aplicadas al estudio de arañas migalomorfas. Entre las herramientas incorporadas se encuentran la morfometría lineal, el análisis de landmarks y de contornos mediante elípticos de Fourier. Estos conocimientos fueron aplicados al estudio de distintas estructuras morfológicas de tarántulas, con especial énfasis en ejemplares del género Phrixotrichus, para evaluar la variación en la forma del bulbo palpal y su utilidad en la diferenciación de especies.",
      "El trabajo incluyó distintas etapas del análisis morfométrico, desde la obtención y el procesamiento de los contornos hasta la realización de análisis multivariados y la representación de la variación de la forma. La experiencia permitió incorporar nuevas herramientas metodológicas que podrán ser aplicadas al estudio de otros grupos de migalomorfas dentro de nuestro grupo de investigación, al mismo tiempo que contribuyó a fortalecer los vínculos de colaboración científica entre investigadores de Argentina y Brasil.",
      "La movilidad fue posible gracias al apoyo del Programa AUIP, que permitió financiar el traslado y llevar adelante esta experiencia de formación e intercambio científico. Agradecemos especialmente al grupo de Aracnología de Río Claro por la recepción, la generosidad y el acompañamiento durante la estadía, así como por el intercambio de conocimientos y experiencias que hicieron posible esta enriquecedora experiencia de formación y colaboración científica."
    ]
  },
  {
    slug: "tarantulas-de-argentina",
    kind: "libro",
    carpeta: "Libro",
    # EXIF de las dos fotos del libro: 30-10-2025.
    published_at: Time.zone.local(2025, 10, 30, 12),
    title: "Tarántulas de Argentina",
    excerpt: "Un recorrido exhaustivo y actualizado sobre la fauna de arañas Theraphosidae de la Argentina: 56 especies, 200 fotos color y mapas de distribución.",
    parrafos: [
      "<strong>Autores:</strong> Nelson Ferretti, Gabriel Pompozzi, Sofía Copperi y Jorge Barneche.",
      "Las grandes arañas, como arañas pollito o tarántulas, han impresionado al hombre desde tiempos inmemoriales debido a su apariencia imponente y sus comportamientos extraordinarios. La mitad de sus especies están representadas en el continente americano, y este libro hace un recorrido exhaustivo y actualizado sobre la fauna de arañas Theraphosidae presentes en la Argentina.",
      "Contiene detalladas fichas descriptivas de cada especie, ilustradas con fotografías color de gran calidad que permiten su reconocimiento. Además, incluye información sobre taxonomía, biología, morfología y biogeografía. Un libro imprescindible tanto para el público general como para los iniciados en el estudio de las arañas. 56 especies · 200 fotos color · mapas de distribución.",
      %(<strong>Dónde comprarlo:</strong> <a href="https://www.vmeditores.com.ar/productos/tarantulas-de-argentina-pre-venta/" rel="noopener" target="_blank">Vázquez Mazzini Editores</a>.)
    ]
  }
]

# Hasta que llegó el material del Drive, las novedades eran todas inventadas.
Post.where("title LIKE ?", "#{MARK}%").destroy_all

sin_fotos = []

posts.each do |attributes|
  carpeta = attributes.delete(:carpeta)
  parrafos = attributes.delete(:parrafos)

  post = Post.find_or_initialize_by(slug: attributes[:slug])
  post.assign_attributes(attributes)

  cuerpo = parrafos.map { |p| "<p>#{p}</p>" }

  # Las fotos se suben como blobs y se referencian por sgid, que es como Trix
  # las embebe. Así el grupo las ve y las puede mover desde el editor.
  #
  # La `url` hace falta para el editor, no para el sitio: el sitio arma la
  # imagen desde el blob, pero Trix la muestra con esa url. Sin ella, en
  # /admin la foto aparece como un recuadro vacío.
  fotos = SeedSupport.photos_in(news_index[SeedSupport.normalize(carpeta)])
  sin_fotos << attributes[:title] if fotos.empty?

  fotos.each do |foto|
    blob = ActiveStorage::Blob.create_and_upload!(
      io: foto.open,
      filename: foto.basename.to_s,
      content_type: Marcel::MimeType.for(foto)
    )
    url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    cuerpo << %(<action-text-attachment sgid="#{blob.attachable_sgid}" url="#{url}" presentation="gallery"></action-text-attachment>)
  end

  post.body = cuerpo.join("\n")
  post.save!
end

puts "Novedades: #{Post.count} notas (contenido real)"
puts "  Con fotos embebidas: #{Post.count - sin_fotos.size} de #{Post.count}"
puts "  Sin fotos en el Drive: #{sin_fotos.join(', ')}" if sin_fotos.any?
