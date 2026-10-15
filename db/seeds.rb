# =============================================================================
# SEEDS — mezcla de contenido REAL del grupo y relleno de EJEMPLO
# =============================================================================
#
# Casi todo es real y sale del material del Drive (drive/, ver CLAUDE.md), en
# archivos aparte y sin prefijo:
#     - db/seeds/members.rb       equipo (7 integrantes, bilingüe ES/EN)
#     - db/seeds/posts.rb         novedades
#     - db/seeds/projects.rb      proyectos (18)
#     - db/seeds/campaigns.rb     campañas (25, con coordenadas APROXIMADAS)
#     - db/seeds/outreach.rb      divulgación
#     - db/seeds/cover_photos.rb  portada
#
# Lo único de EJEMPLO son las publicaciones, acá abajo, con prefijo
# "[EJEMPLO]" para que sea imposible confundirlas con contenido real. Las
# reales van a llegar por la sincronización con BICYT (CLAUDE.md).
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

load Rails.root.join("db/seeds/support.rb")

puts "Cargando seeds (solo publicaciones son de ejemplo)..."

# -- Novedades ---------------------------------------------------------------
# Las novedades NO son de ejemplo: las 3 notas salen de drive/NEWS/, con el
# texto final del grupo y las fotos embebidas en el cuerpo.

load Rails.root.join("db/seeds/posts.rb")

# -- Equipo ------------------------------------------------------------------
# El equipo NO es de ejemplo: los 7 integrantes salen de los .docx que dejaron
# en drive/EQUIPO/, ya traducidos al inglés por ellos mismos.

load Rails.root.join("db/seeds/members.rb")

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
# Real: los 18 proyectos y sus fotos, de drive/PROYECTOS/.

load Rails.root.join("db/seeds/projects.rb")

# -- Campañas ----------------------------------------------------------------
# Las campañas NO son de ejemplo: nombres, años y lugares salen de las carpetas
# que el grupo dejó en el Drive. Lo aproximado son las coordenadas.

load Rails.root.join("db/seeds/campaigns.rb")

# -- Divulgación -------------------------------------------------------------
# Tampoco es de ejemplo: artículos de los boletines del CERZOS, la guía de
# Coronel Suárez y los 7 videos, de drive/DIVULGACION/.

load Rails.root.join("db/seeds/outreach.rb")

# -- Portada -----------------------------------------------------------------
# Real: las fotos de drive/PORTADA/. Todas las fotos del sitio salen ya del
# Drive (equipo, proyectos, campañas, portada); db/seeds/images/ queda solo
# para el logo.

load Rails.root.join("db/seeds/cover_photos.rb")

IMAGES = Rails.root.join("db/seeds/images")

# Logo del grupo, si lo dejaron. El del menú es un placeholder (CLAUDE.md).
logo = Dir.glob(IMAGES.join("logo", "logo.{svg,png,jpg,jpeg,webp}"), File::FNM_CASEFOLD).min
if logo
  FileUtils.mkdir_p(Rails.root.join("app/assets/images"))
  FileUtils.cp(logo, Rails.root.join("app/assets/images", File.basename(logo)))
end

puts "  Portada: #{CoverPhoto.count} · logo: #{logo ? 'sí' : 'no'}"

puts <<~SUMMARY

  Listo.

    Novedades .......... #{Post.count}  real (drive/NEWS)
    Equipo ............. #{Member.count}  real (drive/EQUIPO)
    Publicaciones ...... #{Publication.count}  EJEMPLO — las reales llegan con la sincronización de BICYT
    Proyectos .......... #{Project.count}  real (drive/PROYECTOS)
    Campañas ........... #{Campaign.count}  real (drive/CAMPAÑAS), coordenadas aproximadas
    Divulgación ........ #{OutreachItem.count}  real (drive/DIVULGACION + títulos de YouTube)

  Lo marcado EJEMPLO no es contenido del grupo: reemplazar cuando llegue.
SUMMARY
