# =============================================================================
# DATOS DE EJEMPLO — NO SON CONTENIDO REAL DEL GRUPO
# =============================================================================
#
# Todo lo que se carga acá es relleno para poder ver el sitio funcionando
# mientras el grupo termina de juntar el material. Cada registro lleva el
# prefijo "[EJEMPLO]" justamente para que sea imposible confundirlo con
# contenido real si se cuela en algún lado.
#
# Sigue pendiente del cliente (CLAUDE.md):
#   - nombres, rangos y descripciones del equipo
#   - datos de publicaciones, proyectos y campañas
#   - títulos de los videos de divulgación
#   - coordenadas de las campañas
#   - fotos y logo
#
# Lo único real acá son los IDs de YouTube: salieron de docs/pedido.md, los
# pasó el grupo. Los títulos que los acompañan sí son inventados.
#
# No hay imágenes ni PDFs adjuntos: Active Storage necesita archivos de
# verdad y todavía no los tenemos.
#
#   bin/rails db:seed
#
# En producción no corre salvo que se pida explícitamente:
#
#   SEED_PLACEHOLDERS=true bin/rails db:seed
#
# =============================================================================

MARK = "[EJEMPLO]".freeze

if Rails.env.production? && ENV["SEED_PLACEHOLDERS"] != "true"
  abort <<~MSG
    Estos seeds son datos de ejemplo, no contenido real del grupo.
    Si de verdad los querés en producción: SEED_PLACEHOLDERS=true bin/rails db:seed
  MSG
end

def example(text) = "#{MARK} #{text}"

puts "Cargando datos de EJEMPLO (no son reales)..."

# -- Novedades ---------------------------------------------------------------
# Los temas salen del pedido del grupo; los textos son inventados.

posts = [
  {
    slug: "ejemplo-semana-de-la-ciencia",
    title: example("Semana de la Ciencia"),
    title_en: example("Science Week"),
    kind: "divulgacion",
    published_at: 2.weeks.ago,
    excerpt: example("Texto de ejemplo: resumen corto de la actividad, dos o tres renglones."),
    excerpt_en: example("Placeholder: short summary of the activity."),
    body: "<p>#{example('Cuerpo de ejemplo.')} Acá va la nota completa, escrita desde el panel de carga con el editor de texto. Admite negrita, cursiva, listas e imágenes.</p>"
  },
  {
    slug: "ejemplo-pasantia",
    title: example("Pasantía en el laboratorio"),
    kind: "equipo",
    published_at: 1.month.ago,
    excerpt: example("Texto de ejemplo: resumen de la pasantía."),
    body: "<p>#{example('Cuerpo de ejemplo.')} Nota sobre una pasantía en el grupo.</p>"
  },
  {
    slug: "ejemplo-premio-divulgacion",
    title: example("Premio a mejor artículo de divulgación"),
    kind: "premio",
    published_at: 2.months.ago,
    excerpt: example("Texto de ejemplo: el grupo recibió una distinción."),
    body: "<p>#{example('Cuerpo de ejemplo.')} Jornada del CERZOS.</p>"
  },
  {
    slug: "ejemplo-libro-tarantulas",
    title: example("Libro: Tarántulas de Argentina"),
    kind: "libro",
    published_at: 3.months.ago,
    excerpt: example("Texto de ejemplo: salió publicado un libro del grupo."),
    body: "<p>#{example('Cuerpo de ejemplo.')} Reseña del libro. El PDF, si lo hubiera, iría adjunto al pie y nunca como cuerpo de la nota.</p>"
  },
  {
    slug: "ejemplo-resumen-publicaciones",
    title: example("Resumen de las últimas publicaciones"),
    kind: "publicaciones",
    published_at: 4.months.ago,
    excerpt: example("Texto de ejemplo: repaso de los artículos del año."),
    body: "<p>#{example('Cuerpo de ejemplo.')} Repaso de los artículos publicados.</p>"
  }
]

posts.each do |attributes|
  body = attributes.delete(:body)
  post = Post.find_or_initialize_by(slug: attributes[:slug])
  post.assign_attributes(attributes)
  post.body = body
  post.save!
end

# -- Equipo ------------------------------------------------------------------
# Nombres, cargos y descripciones: todos inventados. Los reales los manda el grupo.

members = [
  {
    name: example("Nombre Apellido (responsable)"),
    rank: "Investigador/a responsable",
    rank_en: "Principal investigator",
    focus: example("Sistemática y biogeografía de Mygalomorphae."),
    focus_en: example("Systematics and biogeography of Mygalomorphae."),
    bio: example("Descripción de ejemplo. Un párrafo corto sobre la trayectoria."),
    email: "ejemplo@cerzos-conicet.gob.ar",
    conicet_url: "https://www.conicet.gov.ar/new_scp/ejemplo",
    researchgate_url: "https://www.researchgate.net/profile/ejemplo",
    position: 1,
    sede: "CERZOS"
  },
  {
    name: example("Nombre Apellido (posdoc)"),
    rank: "Posdoc",
    rank_en: "Postdoctoral researcher",
    focus: example("Ecología térmica y comportamiento."),
    bio: example("Descripción de ejemplo."),
    email: "ejemplo.posdoc@cerzos-conicet.gob.ar",
    position: 2,
    sede: "CERZOS"
  },
  {
    name: example("Nombre Apellido (becario/a)"),
    rank: "Becario/a doctoral",
    rank_en: "Doctoral fellow",
    focus: example("Delimitación de especies con datos moleculares."),
    bio: example("Descripción de ejemplo."),
    position: 3,
    sede: "AGRO"
  },
  {
    name: example("Nombre Apellido (pasante)"),
    rank: "Pasante",
    rank_en: "Intern",
    focus: example("Inventarios biológicos y bases de datos."),
    bio: example("Descripción de ejemplo."),
    position: 4,
    sede: "AGRO"
  }
]

members.each do |attributes|
  Member.find_or_initialize_by(name: attributes[:name]).update!(attributes)
end

# -- Publicaciones -----------------------------------------------------------
# DOIs inventados con prefijo 10.0000 (rango reservado, no resuelve a nada real).

publications = [
  {
    doi: "10.0000/ejemplo.2025.001",
    title: example("Una especie nueva de Mygalomorphae del centro de Argentina"),
    title_en: example("A new Mygalomorphae species from central Argentina"),
    authors: example("Apellido N., Apellido M."),
    year: 2025,
    journal: example("Revista de ejemplo"),
    kind: "cientifica"
  },
  {
    doi: "10.0000/ejemplo.2024.002",
    title: example("Patrones biogeográficos en migalomorfas del sur bonaerense"),
    authors: example("Apellido N., Apellido M., Apellido P."),
    year: 2024,
    journal: example("Revista de ejemplo"),
    kind: "cientifica"
  },
  {
    doi: "10.0000/ejemplo.2023.003",
    title: example("Ecología térmica en arañas de cueva"),
    authors: example("Apellido M."),
    year: 2023,
    journal: example("Revista de ejemplo"),
    kind: "cientifica"
  },
  {
    # Las de divulgación no siempre tienen DOI: por eso el campo es opcional
    # salvo en las científicas.
    title: example("Arañas grandes, miedos chicos: nota de divulgación"),
    authors: example("Apellido N."),
    year: 2024,
    journal: example("Suplemento de ciencia"),
    kind: "divulgacion"
  }
]

publications.each do |attributes|
  key = attributes[:doi].present? ? { doi: attributes[:doi] } : { title: attributes[:title] }
  Publication.find_or_initialize_by(**key).update!(attributes)
end

# -- Proyectos ---------------------------------------------------------------
# Los financiadores (PICT, Rufford, PNUD) sí son los que mencionó el grupo.

projects = [
  {
    title: example("Diversidad y evolución de Mygalomorphae"),
    title_en: example("Diversity and evolution of Mygalomorphae"),
    funder: "pict",
    year_start: 2023,
    year_end: 2026,
    description: example("Descripción de ejemplo del proyecto, dos o tres renglones."),
    description_en: example("Placeholder project description.")
  },
  {
    title: example("Conservación de migalomorfas amenazadas"),
    funder: "rufford",
    year_start: 2022,
    year_end: 2024,
    description: example("Descripción de ejemplo del proyecto.")
  },
  {
    title: example("Inventario de biodiversidad en pastizales"),
    funder: "pnud",
    year_start: 2024,
    # Sin year_end: proyecto en curso.
    description: example("Descripción de ejemplo del proyecto.")
  }
]

projects.each do |attributes|
  Project.find_or_initialize_by(title: attributes[:title]).update!(attributes)
end

# -- Campañas ----------------------------------------------------------------
# Coordenadas aproximadas de localidades reales del sudoeste bonaerense, para
# poder probar el mapa. Las de verdad las pasa el grupo.

campaigns = [
  {
    name: example("Campaña Sierra de la Ventana"),
    name_en: example("Sierra de la Ventana field campaign"),
    locality: "Sierra de la Ventana",
    province: "Buenos Aires",
    lat: -38.133300,
    lng: -61.783300,
    date: Date.new(2025, 3, 10),
    days: 5,
    description: example("Descripción de ejemplo: qué se hizo en la campaña."),
    description_en: example("Placeholder: what the campaign covered.")
  },
  {
    name: example("Campaña Bahía Blanca"),
    locality: "Bahía Blanca",
    province: "Buenos Aires",
    lat: -38.719600,
    lng: -62.272400,
    date: Date.new(2024, 11, 2),
    days: 3,
    description: example("Descripción de ejemplo.")
  },
  {
    name: example("Campaña Tornquist"),
    locality: "Tornquist",
    province: "Buenos Aires",
    lat: -38.100000,
    lng: -62.216700,
    date: Date.new(2024, 4, 18),
    days: 4,
    description: example("Descripción de ejemplo.")
  }
]

campaigns.each do |attributes|
  Campaign.find_or_initialize_by(name: attributes[:name]).update!(attributes)
end

# -- Divulgación -------------------------------------------------------------
# Los IDs de YouTube son los que pasó el grupo en docs/pedido.md. Los títulos
# son inventados: los reales están pendientes.

outreach_items = [
  { youtube_id: "c8wVs0mjo2g", kind: "video",    title: example("Video de divulgación 1") },
  { youtube_id: "G0rQ4M6Bn2g", kind: "video",    title: example("Video de divulgación 2") },
  { youtube_id: "PL6qyA57C9DZ1pFmW1XenrqlcDU0navmSq", kind: "playlist",
    title: example("Lista de reproducción del grupo") },
  { youtube_id: "VmMngNKGHZs", kind: "video",    title: example("Video de divulgación 3") },
  { youtube_id: "AWkgMSYrO58", kind: "video",    title: example("Video de divulgación 4") },
  { youtube_id: "oY8VEKq4E_E", kind: "video",    title: example("Video de divulgación 5") },
  { youtube_id: "R7u8xPvLqO4", kind: "video",    title: example("Video de divulgación 6") },
  { kind: "guia",      title: example("Guía de biodiversidad de Suárez"),
    url: "https://ejemplo.invalid/guia-suarez" },
  { kind: "actividad", title: example("Semana de la Ciencia"),
    url: "https://ejemplo.invalid/semana-de-la-ciencia" },
  { kind: "actividad", title: example("Proyectos de extensión"),
    url: "https://ejemplo.invalid/extension" }
]

outreach_items.each_with_index do |attributes, index|
  item = OutreachItem.find_or_initialize_by(title: attributes[:title])
  item.assign_attributes(attributes.merge(position: index + 1))
  item.save!
end

puts <<~SUMMARY

  Listo. Datos de EJEMPLO cargados:

    Novedades .......... #{Post.count}
    Equipo ............. #{Member.count}
    Publicaciones ...... #{Publication.count}
    Proyectos .......... #{Project.count}
    Campañas ........... #{Campaign.count}
    Divulgación ........ #{OutreachItem.count}

  Nada de esto es contenido real. Reemplazar cuando llegue el material.
SUMMARY
