# =============================================================================
# SEEDS — mezcla de contenido REAL del grupo y relleno de EJEMPLO
# =============================================================================
#
# Ya NO es todo relleno. Desde que llegó el material del Drive hay dos clases
# de registro, y hay que no confundirlas:
#
#   REAL, en archivos aparte, sin prefijo:
#     - db/seeds/members.rb    equipo (7 integrantes, bilingüe ES/EN)
#     - db/seeds/campaigns.rb  campañas (25, con coordenadas APROXIMADAS)
#
#   EJEMPLO, acá abajo, con prefijo "[EJEMPLO]" en cada registro para que sea
#   imposible confundirlo con contenido real si se cuela en algún lado:
#     - novedades, publicaciones, proyectos, divulgación
#
# Sigue pendiente del cliente (CLAUDE.md):
#   - datos de publicaciones y proyectos (el Drive no trae nada de eso)
#   - descripciones de las campañas y sus coordenadas reales
#   - títulos de 5 de los 7 videos de divulgación
#   - fotos de portada (la carpeta PORTADA del Drive está vacía)
#
# Los IDs de YouTube son reales: los pasó el grupo. Los títulos que los
# acompañan son inventados salvo los dos que vinieron nombrados.
#
# Las imágenes son opcionales: si dejás fotos en db/seeds/images/ se adjuntan
# a estos registros (ver el README de esa carpeta). Si no hay ninguna, el
# sitio muestra los huecos marcados como "foto pendiente" y sigue andando.
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

puts "Cargando seeds (solo publicaciones y proyectos son de ejemplo)..."

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
# Las campañas NO son de ejemplo: nombres, años y lugares salen de las carpetas
# que el grupo dejó en el Drive. Lo aproximado son las coordenadas.

load Rails.root.join("db/seeds/campaigns.rb")

# -- Divulgación -------------------------------------------------------------
# Tampoco es de ejemplo: artículos de los boletines del CERZOS, la guía de
# Coronel Suárez y los 7 videos, de drive/DIVULGACION/.

load Rails.root.join("db/seeds/outreach.rb")

# -- Imágenes ----------------------------------------------------------------
# Fotos sueltas para poder ver el sitio armado. Se adjuntan por orden
# alfabético de nombre de archivo, sin que haga falta saber qué foto va con
# qué registro (db/seeds/images/README.md).
#
# Nada de esto es contenido aprobado: cuando llegue el material de verdad se
# carga desde el panel, no desde acá.

IMAGES = Rails.root.join("db/seeds/images")
IMAGE_EXTENSIONS = %w[jpg jpeg png webp avif].freeze

def seed_images(folder)
  Dir.glob(IMAGES.join(folder, "*.{#{IMAGE_EXTENSIONS.join(',')}}"), File::FNM_CASEFOLD)
     .sort_by { |path| File.basename(path).downcase }
     .map { |path| Pathname.new(path) }
end

# Adjunta un archivo solo si el registro todavía no tiene foto, así volver a
# correr los seeds no duplica adjuntos.
def attach_once(attachment, path)
  return if attachment.attached?

  attachment.attach(io: path.open, filename: path.basename.to_s)
end

attached = 0

# El equipo tampoco usa estos placeholders: sus fotos son reales y salen de
# drive/EQUIPO/, se adjuntan en db/seeds/members.rb.

seed_images("proyectos").zip(Project.recent.to_a).each do |path, project|
  next if path.nil? || project.nil?

  attach_once(project.photo, path)
  attached += 1
end

# Las campañas NO usan estos placeholders: sus fotos son reales y salen de
# drive/CAMPAÑAS/, se adjuntan en db/seeds/campaigns.rb.

# La portada no tiene modelo propio todavía (no está en el modelo de datos de
# CLAUDE.md), así que sus fotos se copian al pipeline de assets y la vista las
# levanta del disco. Es provisorio: cuando lleguen las definitivas hay que
# decidir dónde viven para que el grupo pueda cambiarlas desde el panel.
portada_destino = Rails.root.join("app/assets/images/portada")
portada = seed_images("portada")

if portada.any?
  FileUtils.mkdir_p(portada_destino)
  portada.each { |path| FileUtils.cp(path, portada_destino.join(path.basename)) }
end

# Logo del grupo, si lo dejaron. El del menú es un placeholder (CLAUDE.md).
logo = Dir.glob(IMAGES.join("logo", "logo.{svg,png,jpg,jpeg,webp}"), File::FNM_CASEFOLD).min
if logo
  FileUtils.mkdir_p(Rails.root.join("app/assets/images"))
  FileUtils.cp(logo, Rails.root.join("app/assets/images", File.basename(logo)))
end

puts "  Imágenes adjuntadas: #{attached} · portada: #{portada.size} · logo: #{logo ? 'sí' : 'no'}"

puts <<~SUMMARY

  Listo.

    Novedades .......... #{Post.count}  real (drive/NEWS)
    Equipo ............. #{Member.count}  real (drive/EQUIPO)
    Publicaciones ...... #{Publication.count}  EJEMPLO — el cliente no mandó nada
    Proyectos .......... #{Project.count}  EJEMPLO — el cliente no mandó nada
    Campañas ........... #{Campaign.count}  real (drive/CAMPAÑAS), coordenadas aproximadas
    Divulgación ........ #{OutreachItem.count}  real (drive/DIVULGACION + títulos de YouTube)

  Lo marcado EJEMPLO no es contenido del grupo: reemplazar cuando llegue.
SUMMARY
