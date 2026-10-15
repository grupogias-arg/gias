# =============================================================================
# DIVULGACIÓN — contenido REAL del grupo
# =============================================================================
#
# Sale de drive/DIVULGACION/:
#   - Untitled document.docx → artículos de los boletines del CERZOS
#   - videos.docx            → los videos de YouTube
#
# Los IDs de YouTube ya estaban en docs/pedido.md (la transcripción del pedido
# original) y coinciden exactamente con los del Drive.
#
# Los títulos de los videos salen de YouTube, tal cual y sin descripción, como
# pidió Fiorela. Se traen con el endpoint oEmbed público:
#
#   curl "https://www.youtube.com/oembed?url=<url del video>&format=json"
#
# No lleva prefijo "[EJEMPLO]": es contenido del grupo.
# =============================================================================

BOLETIN_41 = "https://boletines.cerzos-conicet.gob.ar/wp-content/uploads/2026/02/boletin-cerzos-41.pdf".freeze
BOLETIN_40 = "https://boletines.cerzos-conicet.gob.ar/wp-content/uploads/2025/07/Boletin_del_CERZOS_2025.pdf".freeze
BOLETIN_39 = "https://boletines.cerzos-conicet.gob.ar/wp-content/uploads/2024/12/Boletin_del_CERZOS_-_39_compressed.pdf".freeze
BOLETIN_37 = "https://boletines.cerzos-conicet.gob.ar/wp-content/uploads/2023/05/Boletin-del-CERZOS-37-MAYO2023.pdf".freeze

outreach_items = [
  # -- Videos ----------------------------------------------------------------
  # Los títulos son los de YouTube, tal cual, sin agregados: Fiorela pidió
  # expresamente que no lleven descripción.
  #
  # Difieren de lo que decía videos.docx, que traía texto propio encima: los
  # dos primeros estaban anotados en inglés aunque el video es en español, y
  # al de Radio UNS le sumaba "Premio a Mejor Artículo de Divulgación Micaela
  # Millenpeier", que es descripción y no el título.
  #
  # Tampoco llevan `title_en`: son títulos propios de videos en español, no
  # hay nada que traducir. El fallback del Translatable muestra el español.
  {
    youtube_id: "c8wVs0mjo2g", kind: "video", position: 1,
    title: "Científicos Industria Argentina - Arañas migalomorfas (Sierra de la Ventana) - 19-04-14 (1 de 2)"
  },
  {
    youtube_id: "G0rQ4M6Bn2g", kind: "video", position: 2,
    title: "Científicos Industria Argentina - Arañas migalomorfas (Sierra de la Ventana) - 19-04-14 (2 de 2)"
  },
  {
    youtube_id: "VmMngNKGHZs", kind: "video", position: 3,
    title: "Todo a Conciencia N° 14 - Radio UNS | CERZOS 2"
  },
  {
    youtube_id: "AWkgMSYrO58", kind: "video", position: 4,
    title: "Micaela - Maite - Micaela - Carolina - GIAS | #FuturoPerfecto - 13/09 | Vorterix Bahía"
  },
  {
    youtube_id: "oY8VEKq4E_E", kind: "video", position: 5,
    title: "MITOS Y VERDADES DE LAS ARAÑAS EN BAHÍA BLANCA"
  },
  {
    youtube_id: "R7u8xPvLqO4", kind: "video", position: 6,
    title: "CRÁNEOS - EPISODIO 13: CÓMO PERDER EL MIEDO A LAS ARAÑAS"
  },
  {
    youtube_id: "PL6qyA57C9DZ1pFmW1XenrqlcDU0navmSq", kind: "playlist", position: 7,
    title: "Futuro Perfecto - Vorterix Bahía"
  },

  # -- Artículos de los boletines del CERZOS ---------------------------------
  {
    kind: "articulo", position: 10, url: BOLETIN_41,
    title: "Los misterios del arcoíris peludo: por qué algunas tarántulas tienen colores tan llamativos",
    authors: "Nelson Ferretti"
  },
  {
    kind: "articulo", position: 11, url: BOLETIN_41,
    title: "En los confines del viento: recorriendo la Patagonia tras los pasos de la tarántula más austral del mundo",
    authors: "Micaela Nicoletta, Leonela Schwerdt, Justina Panchuk, Arthur Galleti-Lima y Nelson Ferretti"
  },
  {
    kind: "articulo", position: 12, url: BOLETIN_40,
    title: "Tejiendo la supervivencia: arañas y sus adaptaciones a las inundaciones",
    authors: "Maite Allegue y Micaela Nicoletta"
  },
  {
    kind: "articulo", position: 13, url: BOLETIN_40,
    title: "Aquí, bajo el sol… aquí, hace tanto calor: descubriendo el microambiente térmico de tarántulas con modelos 3D",
    authors: "Leonela Schwerdt y Rodrigo Batista"
  },
  {
    kind: "articulo", position: 14, url: BOLETIN_39,
    title: "Una o más especies, esa es la cuestión… al menos en arañas",
    authors: "Nelson Ferretti"
  },
  {
    kind: "articulo", position: 15, url: BOLETIN_37,
    title: "Las arañas: ¿team verano o team invierno?",
    authors: "Justina Panchuk"
  },
  {
    kind: "articulo", position: 16, url: BOLETIN_37,
    title: "Una de cal y una de arena: conociendo a las arañas albañiles",
    authors: "Micaela Nicoletta"
  },

  # -- Guías -----------------------------------------------------------------
  {
    kind: "guia", position: 20,
    title: "Guía de biodiversidad de Coronel Suárez",
    authors: "DBByF — UNS",
    url: "https://www.coronelsuarez.gob.ar/wp-content/uploads/2023/04/Biodiversidad-Cnel-Su%C3%A1rez-DBByF-UNS-2023-1.pdf"
  }
]

# Hasta que llegó el material del Drive, esta sección era toda inventada.
OutreachItem.where("title LIKE ?", "#{MARK}%").destroy_all

outreach_items.each do |attributes|
  # Los videos se identifican por su ID de YouTube: varios comparten el título
  # provisorio mientras el grupo no mande los reales, y buscar por título los
  # colapsaría en un solo registro. Artículos y guías sí van por título, porque
  # dos artículos del mismo boletín comparten la URL.
  clave =
    if attributes[:youtube_id].present?
      { youtube_id: attributes[:youtube_id] }
    else
      { title: attributes[:title] }
    end

  # `title_en: nil` por defecto: si un item deja de tener traducción, `update!`
  # solo pisa lo que se le pasa y el valor viejo sobreviviría en la base.
  OutreachItem.find_or_initialize_by(**clave).update!({ title_en: nil }.merge(attributes))
end

puts "Divulgación: #{OutreachItem.count} items (contenido real)"
puts "  Videos: #{OutreachItem.videos.count} · Artículos: #{OutreachItem.articulo.count} · Guías: #{OutreachItem.guia.count}"
