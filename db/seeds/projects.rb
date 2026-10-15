# =============================================================================
# PROYECTOS — contenido REAL del grupo
# =============================================================================
#
# Sale de drive/PROYECTOS/:
#   - Proyectos.docx      → los 18 proyectos, con título, año y descripción
#   - Proyecto <n>.jpg    → la foto de cada uno, por número
#
# Títulos y descripciones van textuales. Los de subsidios internacionales
# vinieron con el título en inglés y la descripción en español; no se traducen
# acá (no hay `_en`): el fallback del Translatable muestra lo que hay.
#
# El documento da un solo año por proyecto, así que `year_end` = `year_start`
# y la vista muestra el año solo. Dejarlo vacío lo mostraría "en curso", y eso
# el grupo no lo dijo.
#
# El financiador sale de la descripción ("Financiado por ...").
#
# No lleva prefijo "[EJEMPLO]": es contenido del grupo.
# =============================================================================

projects = [
  { number: 1, funder: "aas", year: 2009,
    title: "Distribution and ethological reproductive isolation between two possible sympatric species of Grammostola (Araneae: Theraphosidae) in Buenos Aires, Argentina",
    description: "Financiado por la American Arachnological Society (USA) para estudiar el aislamiento reproductivo entre diferentes poblaciones de especies simpátricas de tarántulas, a campo y en laboratorio." },
  { number: 2, funder: "aas", year: 2010,
    title: "The most unusual mygalomorph spider Mecicobothrium thorelli Homberg, 1882 in hilly system of Southeast Buenos Aires province, Argentina",
    description: "Financiado por la American Arachnological Society (USA) con el fin de aportar conocimiento sobre la biología y comportamiento reproductivo de una especie rara de Mygalomorphae del sistema serrano de Ventania." },
  { number: 3, funder: "aas", year: 2011,
    title: "Reproductive biology of the microstigmatid Xenonemesia platensis Goloboff 1989 from Martín García island, Buenos Aires, Argentina",
    description: "Financiado por la American Arachnological Society (USA) con el fin de estudiar el comportamiento reproductivo de una especie de Mygalomorphae presente en la isla Martín García." },
  { number: 4, funder: "bts", year: 2012,
    title: "Research on Andean Tarantulas",
    description: "Financiado por la British Tarantula Society (UK) para evaluar la diversidad de tarántulas en los bosques andino-patagónicos de la provincia de Neuquén." },
  { number: 5, funder: "aas", year: 2012,
    title: "Diversity of mygalomorph spiders (Araneae) in Mendoza province, Argentina: how many species are there?",
    description: "Financiado por la American Arachnological Society (USA) para estudiar la diversidad de especies de arañas Mygalomorphae en áreas naturales de la provincia de Mendoza." },
  { number: 6, funder: "rufford", year: 2013,
    title: "Conserving Tarantulas in the Atlantic Forest, Argentina",
    description: "Financiado por la Rufford Small Grants Foundation (UK) para estimar la diversidad de tarántulas en el bosque atlántico de la provincia de Misiones y aportar conocimientos para su conservación." },
  { number: 7, funder: "aas", year: 2013,
    title: "Density of Acanthogonatus centralis Goloboff 1995 (Araneae:Mygalomorphae) in three different disturbed habitats",
    description: "Financiado por la American Arachnological Society (USA) para evaluar la densidad poblacional de una especie de Mygalomorphae en diferentes ambientes con distintos grados de disturbio en el sistema de Ventania." },
  { number: 8, funder: "aas", year: 2015,
    title: "Ecology and conservation biology of the threatened Argentinean tarantula Grammostola vachoni: emphasis on Ventania System (Buenos Aires)",
    description: "Financiado por la American Arachnological Society (USA) para estudiar la ecología y estado de conservación de la especie de araña Mygalomorphae Grammostola vachoni en las sierras bonaerenses." },
  { number: 9, funder: "pict", year: 2015,
    title: "PICT - Arañas migalomorfas del arco peripampásico: filogeografía, modelos de distribución, cambio climático global y conservación",
    description: "Financiado por FONCyT y Agencia I+D+i para estudiar filogeografía de arañas migalomorfas a lo largo de las sierras centrales de Argentina." },
  { number: 10, funder: "ngc", year: 2018,
    title: "Trapped for life: Research and conservation of endemic and threatened trapdoor spider (Calathotarsus simoni) in native mountainous grasslands, Argentina",
    description: "Financiado por Neotropical Grassland Conservancy para investigar sobre la ecología y conservación de una especie de araña endémica de los sistemas serranos de Ventania y Tandilia (Buenos Aires)." },
  { number: 11, funder: "isa", year: 2019,
    title: "Mygalomorph spiders (Araneae) from the biogeographic island of Paraje Tres Cerros (Corrientes, Argentina): Diversity and taxonomy",
    description: "Financiado por la International Society of Arachnology (UK) para realizar relevamientos la reserva Paraje Tres Cerros en Corrientes para evaluar la diversidad y taxonomía de arañas Mygalomorphae." },
  { number: 12, funder: "aas", year: 2019,
    title: "Ecology and conservation of Mecicobothrium thorelli Holmberg, 1882 (Araneae: Mecicobothriidae) in natural grasslands of Argentina",
    description: "Financiado por la American Arachnological Society (USA) para estudiar la ecología y estado de conservación de la especie de araña Mygalomorphae Mecicobothrium thorelli en las sierras bonaerenses." },
  { number: 13, funder: "sgcyt_uns", year: 2020,
    title: "Arañas migalomorfas de Argentina: diversidad, evolución y conservación",
    description: "Financiado por la SGCyT de la UNS para realización de estudios multidisciplinarios enfocados en las arañas Mygalomorphae para dilucidar los procesos inherentes a la diversidad de este grupo en Argentina." },
  { number: 14, funder: "pict", year: 2020,
    title: "PICT - Diversidad, evolución y biogeografía de arañas migalomorfas de Argentina: una aproximación integradora y su importancia en la conservación",
    description: "Financiado por FONCyT y Agencia I+D+i para delimitación precisa de las especies de arañas Mygalomorphae del centro y norte de Argentina." },
  { number: 15, funder: "isa", year: 2020,
    title: "Discovery and description of a new species of Acanthogonatus (Nemesiidae) from southern Argentina: taxonomy and phylogenetic position",
    description: "Financiado por la International Society of Arachnology (UK) para describir una nueva especie de Acanthogonatus para Argentina." },
  { number: 16, funder: "pict", year: 2021,
    title: "PICT - Biología y ecología térmica de arañas migalomorfas: un enfoque a nivel individuo y población bajo un contexto de cambio climático global",
    description: "Financiado por FONCyT y Agencia I+D+i para determinar el efecto de la temperatura en especies de tarántulas." },
  { number: 17, funder: "sgcyt_uns", year: 2023,
    title: "Sistemática, biogeografía y conservación de arañas migalomorfas de Argentina: énfasis en taxones conflictivos",
    description: "Financiado por la SGCyT de la UNS para realización de estudios multidisciplinarios enfocados en las arañas Mygalomorphae para dilucidar los procesos inherentes a la diversidad de este grupo en Argentina." },
  { number: 18, funder: "pict", year: 2023,
    title: "Sistemática, filogenia, biogeografía y conservación de Grammostola (Araneae: Theraphosidae) en Argentina: un abordaje integral para resolver un problema de 60 años",
    description: "Financiado por FONCyT y Agencia I+D+i para delimitación precisa de las especies de arañas del género Grammostola de Argentina." }
]

# Hasta que llegó el material del Drive, esta sección era inventada.
Project.where("title LIKE ?", "#{MARK}%").destroy_all

# Fotos por número de proyecto. Se busca el número y no el nombre exacto porque
# la 16 vino como "Proyecyo 16.jpg".
DRIVE_PROJECTS = Rails.root.join("drive/PROYECTOS")

project_photos =
  if DRIVE_PROJECTS.directory?
    SeedSupport.photos_in(DRIVE_PROJECTS)
               .index_by { |path| path.basename.to_s[/\d+/].to_i }
  else
    {}
  end

sin_foto = []

projects.each do |attributes|
  number = attributes[:number]
  year = attributes[:year]

  project = Project.find_or_initialize_by(title: attributes[:title])
  project.update!(
    title_en: nil, description_en: nil,
    funder: attributes[:funder],
    year_start: year, year_end: year,
    description: attributes[:description]
  )

  # La foto sale del Drive y de ningún otro lado.
  project.photo.purge if project.photo.attached?
  next if project_photos.empty?

  foto = project_photos[number]
  if foto.nil?
    sin_foto << "Proyecto #{number}"
    next
  end

  project.photo.attach(io: foto.open, filename: foto.basename.to_s)
end

puts "Proyectos: #{Project.count} (contenido real)"
puts "  Fotos reales desde drive/: #{Project.all.count { |p| p.photo.attached? }} de #{Project.count}"
puts "  Sin foto en el Drive: #{sin_foto.join(', ')}" if sin_foto.any?
puts "  (no existe drive/PROYECTOS: los proyectos quedan sin fotos)" if project_photos.empty?
