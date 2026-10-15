# =============================================================================
# EQUIPO — contenido REAL del grupo
# =============================================================================
#
# Sale de los .docx que cada integrante dejó en drive/EQUIPO/, uno por carpeta.
# No lleva el prefijo "[EJEMPLO]": es contenido del grupo, no relleno.
#
# Vienen ya traducidos al inglés por ellos mismos, así que todos los campos
# tienen su par `_en` y no hace falta el fallback al español.
#
# Cada .docx trae un bloque de uno o dos párrafos. Se parte en dos campos
# porque la vista los muestra distinto (ver app/views/members/_member.html.erb):
#   - `focus` → la "Línea:" corta, la idea central
#   - `bio`   → el resto del texto, textual
#
# Las fotos salen de la misma carpeta de cada integrante (hay una sola imagen
# por carpeta). Si drive/ no está, los integrantes se cargan igual, sin foto.
#
# Pendiente: ninguno mandó su perfil de CONICET, solo ResearchGate. Por eso
# `conicet_url` queda vacío y la ficha no muestra ese link.
# =============================================================================

members = [
  {
    name: "Nelson E. Ferretti",
    rank: "Investigador Independiente",
    rank_en: "Independent Researcher",
    sede: "CERZOS · DBByF (UNS)",
    email: "nferretti@conicet.gov.ar",
    researchgate_url: "https://www.researchgate.net/profile/Nelson-Ferretti",
    position: 1,
    focus: "Diversidad y evolución de las arañas migalomorfas neotropicales. En particular, la sistemática, taxonomía, comportamiento y biogeografía de la familia Theraphosidae (tarántulas).",
    focus_en: "Diversity and evolution of Neotropical mygalomorph spiders, particularly the systematics, taxonomy, behavior and biogeography of the family Theraphosidae (tarantulas).",
    bio: "Mis principales intereses de investigación incluyen la filogenética morfológica y molecular, la delimitación de especies y el desarrollo y evaluación de hipótesis biogeográficas que permitan comprender mejor la historia evolutiva y los procesos de diversificación de este grupo de arañas.",
    bio_en: "My research interests include morphological and molecular phylogenetics, species delimitation, and the development and testing of biogeographic hypotheses to better understand the evolutionary history and diversification of this group of spiders."
  },
  {
    name: "Leonela Schwerdt",
    rank: "Investigadora Asistente",
    rank_en: "Assistant Researcher",
    sede: "CERZOS",
    email: "leonelasch@gmail.com",
    researchgate_url: "https://www.researchgate.net/profile/Leonela-Schwerdt",
    position: 2,
    focus: "Biología y ecología térmica de arañas migalomorfas, particularmente tarántulas de Argentina.",
    focus_en: "Biology and thermal ecology of mygalomorph spiders, particularly tarantulas from Argentina.",
    bio: "El objetivo principal es comprender cómo las especies responden a las condiciones ambientales y a la variabilidad térmica, integrando estudios de campo y experimentales a escala individual y poblacional. Las investigaciones incluyen la caracterización del rendimiento y los límites térmicos, el estudio de la calidad térmica y la evaluación de la vulnerabilidad de especies frente al cambio ambiental y climático. Esta línea se complementa con estudios sobre biología y ecología de las especies, con el propósito de generar información que contribuya al conocimiento y conservación de las arañas migalomorfas.",
    bio_en: "The main objective is to understand how the species respond to environmental conditions and thermal variability by integrating field and experimental studies at the individual and population levels. My research includes the characterization of thermal performance and thermal limits, the study of thermal habitat quality, and the assessment of species vulnerability to environmental and climatic change. This work is complemented by studies on biology and ecology, with the aim of generating information that contributes to our understanding and conservation of mygalomorph spiders."
  },
  {
    name: "Justina Panchuk",
    rank: "Becaria Posdoctoral",
    rank_en: "Postdoctoral Researcher",
    sede: "CERZOS",
    email: "panchukjustina@gmail.com",
    researchgate_url: "https://www.researchgate.net/profile/Justina-Panchuk",
    position: 3,
    focus: "Evolución de la morfología reproductiva y el comportamiento sexual en arañas migalomorfas.",
    focus_en: "Evolution of reproductive morphology and sexual behavior in mygalomorph spiders.",
    bio: "En particular, busco caracterizar la mecánica copulatoria y el almacenamiento de esperma mediante la integración de evidencia morfológica, conductual y filogenética, para comprender cómo evolucionaron sus órganos reproductivos y qué papel tuvo la selección sexual en su diversificación.",
    bio_en: "I aim to characterize copulatory mechanics and sperm storage by integrating morphological, behavioral, and phylogenetic evidence, in order to understand how their reproductive organs evolved and what role sexual selection played in their diversification."
  },
  {
    name: "Maite Allegue",
    rank: "Becaria Doctoral",
    rank_en: "PhD Student",
    sede: "CERZOS",
    email: "alleguemaite@gmail.com",
    researchgate_url: "https://www.researchgate.net/profile/Maite-Allegue",
    position: 4,
    focus: "Diversidad y evolución de las arañas migalomorfas, desde una perspectiva que combina sistemática, filogenia, comportamiento y biogeografía. Mi investigación doctoral aborda el género de tarántulas Euathlus (Theraphosidae).",
    focus_en: "Diversity and evolution of mygalomorph spiders, combining systematics, phylogenetics, behavior and biogeography. My PhD research addresses the tarantula genus Euathlus (Theraphosidae).",
    bio: "Mis principales intereses incluyen la revisión taxonómica, la reconstrucción de relaciones filogenéticas, el estudio del comportamiento sexual y el análisis de los patrones de distribución, con el propósito de intentar comprender los procesos evolutivos que dieron forma a la diversidad de este grupo. Además, trabajo con otros linajes de arañas migalomorfas, contribuyendo al conocimiento de su diversidad, biología e historia natural.",
    bio_en: "My main interests include taxonomic revision, phylogenetic relationships, sexual behavior, and species distribution patterns, with the aim of understanding the evolutionary processes that have shaped the diversity of this group. Additionally, I work on other lineages of mygalomorph spiders, contributing to the knowledge of their diversity, biology, and natural history."
  },
  {
    name: "Micaela Nicoletta",
    rank: "Becaria Doctoral",
    rank_en: "PhD Student",
    sede: "CERZOS",
    # El .docx trae un HYPERLINK pegado al mail de Justina (copiaron su
    # plantilla). Vale el texto visible, que es este.
    email: "mmnicolettal@gmail.com",
    researchgate_url: "https://www.researchgate.net/profile/Micaela-Nicoletta",
    position: 5,
    focus: "Estudio sistemático, taxonómico, filogenético y biogeográfico de las arañas migalomorfas del género Grammostola de Argentina.",
    focus_en: "Systematic, taxonomic, phylogenetic and biogeographic study of mygalomorph spiders of the genus Grammostola from Argentina.",
    bio: "El objetivo principal es revisar la diversidad del género mediante el estudio de caracteres morfológicos y filogenéticos, integrando análisis filogenéticos y biogeográficos para esclarecer las relaciones evolutivas, distribución y delimitación de especies. Este trabajo incluye la revisión de especies conocidas, la evaluación de sinonimias y revalidaciones, y la descripción de nuevas especies, contribuyendo al conocimiento de la diversidad y evolución de las tarántulas en el Cono Sur.",
    bio_en: "The main objective is to assess the diversity of the genus through the study of morphological and phylogenetic characters, integrating phylogenetic and biogeographic analyses to clarify evolutionary relationships, species distributions, and species delimitation. This work includes the revision of known species, the assessment of synonymies and species revalidations, and the description of new species, contributing to our understanding of the diversity and evolution of tarantulas in the Southern Cone."
  },
  {
    name: "Micaela Irupé Millenpeier",
    rank: "Becaria Doctoral",
    rank_en: "PhD Student",
    sede: "CERZOS · DBByF (UNS)",
    email: "micaelamillenpeier8@gmail.com",
    researchgate_url: "https://www.researchgate.net/profile/Micaela-Millenpeier",
    position: 6,
    focus: "Biogeografía y conservación de las arañas, con especial interés en los patrones de distribución de las especies y los vacíos de conocimiento que dificultan su conservación.",
    focus_en: "Biogeography and conservation of spiders, with particular interest in species distribution patterns and the knowledge gaps that hinder their conservation.",
    bio: "Además, me interesa integrar herramientas de la biogeografía, la ecología y la sistemática para ampliar el conocimiento sobre la diversidad de especies, su biología e historia natural.",
    bio_en: "I am also interested in integrating approaches from biogeography, ecology, and systematics to expand our understanding of species diversity, biology, and natural history."
  },
  {
    name: "Fiorella Signorotto",
    rank: "Becaria Doctoral",
    rank_en: "PhD Student",
    sede: "CERZOS",
    email: "fsignorotto@cerzos-conicet.gob.ar",
    researchgate_url: "https://www.researchgate.net/profile/Fiorella-Signorotto",
    position: 7,
    focus: "Sistemática y biogeografía histórica de la familia Migidae, un grupo de arañas trapdoor de distribución gondwánica.",
    focus_en: "Systematics and historical biogeography of the family Migidae, a group of Gondwanan-distributed trapdoor spiders.",
    bio: "Busco reconstruir su historia evolutiva mediante la integración de evidencia morfológica, molecular y biogeográfica, explorar los procesos que contribuyeron a su diversificación y avanzar en la revisión taxonómica del grupo.",
    bio_en: "I aim to reconstruct their evolutionary history by integrating morphological, molecular, and biogeographic evidence, exploring the processes that contributed to their diversification, and advancing the taxonomic revision of the group."
  }
]

# Carpeta de cada integrante en el Drive. El nombre de la carpeta no siempre
# coincide con el nombre completo (a Micaela Irupé le pusieron solo "Micaela
# Millenpeier"), así que se mapea explícito.
MEMBER_FOLDERS = {
  "Nelson E. Ferretti" => "Nelson E. Ferretti",
  "Leonela Schwerdt" => "Leonela Schwerdt",
  "Justina Panchuk" => "Justina Panchuk",
  "Maite Allegue" => "Maite Allegue",
  "Micaela Nicoletta" => "Micaela Nicoletta",
  "Micaela Irupé Millenpeier" => "Micaela Millenpeier",
  "Fiorella Signorotto" => "Fiorella Signorotto"
}.freeze

MEMBERS_ROOT = Rails.root.join("drive/EQUIPO")

member_index = SeedSupport.drive_index(MEMBERS_ROOT)

# Hasta que llegó el material del Drive, el equipo eran cuatro personas
# inventadas. Si quedaron cargadas de una corrida anterior, se van.
Member.where("name LIKE ?", "#{MARK}%").destroy_all

sin_foto = []

members.each do |attributes|
  member = Member.find_or_initialize_by(name: attributes[:name])
  member.update!(attributes)

  # La foto sale del Drive y de ningún otro lado.
  member.photo.purge if member.photo.attached?
  next if member_index.empty?

  folder = member_index[SeedSupport.normalize(MEMBER_FOLDERS.fetch(attributes[:name]))]
  foto = SeedSupport.photos_in(folder, limit: 1).first

  if foto.nil?
    sin_foto << attributes[:name]
    next
  end

  member.photo.attach(io: foto.open, filename: foto.basename.to_s)
end

puts "Equipo: #{Member.count} integrantes (contenido real, bilingüe ES/EN)"
puts "  Fotos reales desde drive/: #{Member.all.count { |m| m.photo.attached? }} de #{Member.count}"
puts "  Sin foto en el Drive: #{sin_foto.join(', ')}" if sin_foto.any?
puts "  (no existe drive/EQUIPO: el equipo queda sin fotos)" if member_index.empty?
