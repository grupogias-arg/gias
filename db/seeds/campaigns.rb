# =============================================================================
# CAMPAÑAS — nombres REALES, coordenadas ESTIMADAS
# =============================================================================
#
# A diferencia del resto de db/seeds.rb, esto no es relleno inventado: los
# nombres, años, localidades y provincias salen de las carpetas que el grupo
# dejó en el Drive ("Contenido para web / CAMPAÑAS"). Por eso no llevan el
# prefijo "[EJEMPLO]".
#
# Lo que SÍ es aproximado son las coordenadas. El grupo todavía no pasó las
# reales, así que acá va el centro de la localidad o del área protegida, con
# `coords_estimated: true`. El sitio avisa que la ubicación es aproximada y el
# panel de administración las deja corregir una por una.
#
# Tampoco hay descripciones: las carpetas del Drive solo tenían fotos. Quedan
# en blanco a propósito — la vista omite el párrafo cuando falta.
#
# Las fotos son las primeras 3 de cada carpeta en orden alfabético: el grupo
# dejó 3 en casi todas (la de 2022 del noroeste tiene 8).
#
# Los nombres corrigen erratas de las carpetas: "SIerras" → "Sierras", "BUenos" → "Buenos", "Uruguaí" → "Urugua-í".
# =============================================================================

campaigns = [
  { name: "Sierra de la Ventana",
    locality: "Sierra de la Ventana", province: "Buenos Aires",
    year_start: 2006, year_end: 2011, date: Date.new(2006, 10, 28),
    lat: -38.133300, lng: -61.783300 },

  { name: "Bosques Andino-Patagónicos",
    locality: "Bosques Andino-Patagónicos", province: "Neuquén",
    year_start: 2011, lat: -39.950000, lng: -71.350000 },

  { name: "Isla Martín García",
    locality: "Isla Martín García", province: "Buenos Aires",
    year_start: 2011, lat: -34.183300, lng: -58.251400 },

  { name: "Parque Nacional Lihué Calel",
    locality: "Parque Nacional Lihué Calel", province: "La Pampa",
    year_start: 2011, lat: -38.016700, lng: -65.583300 },

  { name: "Precordillera de Mendoza",
    locality: "Precordillera", province: "Mendoza",
    year_start: 2013, lat: -32.583300, lng: -69.350000 },

  { name: "Reserva de Biósfera Ñacuñán",
    locality: "Ñacuñán", province: "Mendoza",
    year_start: 2013, lat: -34.050000, lng: -67.966700 },

  { name: "Sierras de Córdoba",
    locality: "Sierras de Córdoba", province: "Córdoba",
    year_start: 2013, year_end: 2015, lat: -31.450000, lng: -64.850000 },

  { name: "Centro de Investigaciones Antonia Ramos (CIAR)",
    locality: "Aristóbulo del Valle", province: "Misiones",
    year_start: 2014, lat: -27.095600, lng: -54.906400 },

  { name: "Parque Nacional Iguazú",
    locality: "Parque Nacional Iguazú", province: "Misiones",
    year_start: 2014, lat: -25.695300, lng: -54.436700 },

  { name: "Parque Nacional El Palmar",
    locality: "Parque Nacional El Palmar", province: "Entre Ríos",
    year_start: 2014, lat: -31.883300, lng: -58.283300 },

  { name: "Reserva de Vida Silvestre Urugua-í",
    locality: "Urugua-í", province: "Misiones",
    year_start: 2014, lat: -25.966700, lng: -54.133300 },

  { name: "Sierras del sudoeste bonaerense",
    locality: "Sudoeste bonaerense", province: "Buenos Aires",
    year_start: 2015, lat: -38.066700, lng: -61.983300 },

  { name: "Parque Nacional Lihué Calel",
    locality: "Parque Nacional Lihué Calel", province: "La Pampa",
    year_start: 2016, lat: -38.016700, lng: -65.583300 },

  { name: "San Luis",
    locality: "San Luis", province: "San Luis",
    year_start: 2016, lat: -33.300000, lng: -66.333300 },

  { name: "Noroeste argentino",
    locality: "Tucumán, Catamarca, La Rioja y San Juan", province: "Noroeste argentino",
    year_start: 2017, lat: -28.466700, lng: -66.300000 },

  { name: "Comodoro Rivadavia",
    locality: "Comodoro Rivadavia", province: "Chubut",
    year_start: 2019, lat: -45.864700, lng: -67.480800 },

  { name: "Tres Cerros",
    locality: "Tres Cerros", province: "Corrientes",
    year_start: 2020, lat: -29.133300, lng: -56.933300 },

  { name: "Parque Nacional Chaco y Parque Nacional Copo",
    locality: "PN Chaco y PN Copo", province: "Chaco y Santiago del Estero",
    year_start: 2021, lat: -26.400000, lng: -60.700000 },

  { name: "Parques nacionales del noroeste",
    locality: "PN Calilegua, PN Aconquija, PN Los Cardones y PN Copo",
    province: "Jujuy, Tucumán, Salta y Santiago del Estero",
    year_start: 2022, lat: -24.300000, lng: -64.800000 },

  { name: "Comodoro Rivadavia",
    locality: "Comodoro Rivadavia", province: "Chubut",
    year_start: 2022, lat: -45.864700, lng: -67.480800 },

  { name: "Perú",
    locality: "Perú", province: "Perú",
    year_start: 2023, lat: -9.190000, lng: -75.015200 },

  { name: "Río Negro y Neuquén",
    locality: "Río Negro y Neuquén", province: "Río Negro y Neuquén",
    year_start: 2023, lat: -40.300000, lng: -69.500000 },

  { name: "Reserva Provincial Meseta de Somuncurá",
    locality: "Meseta de Somuncurá", province: "Río Negro",
    year_start: 2024, lat: -41.100000, lng: -66.750000 },

  { name: "Chubut",
    locality: "Chubut", province: "Chubut",
    year_start: 2025, lat: -43.500000, lng: -68.500000 },

  { name: "Parques nacionales y provincias del norte",
    locality: "PN Calilegua, PN Copo, Tucumán, Salta y Santiago del Estero",
    province: "Jujuy, Tucumán, Salta y Santiago del Estero",
    year_start: 2025, lat: -24.800000, lng: -64.500000 }
]

# Carpeta del Drive de la que salen las fotos de cada campaña, indexada por
# [nombre, año de inicio]. Los nombres de carpeta van tal cual, con sus erratas.
DRIVE_FOLDERS = {
  [ "Sierra de la Ventana", 2006 ] => "28-10-2006 - 2011 - Sierra de la Ventana BUenos Aires",
  [ "Bosques Andino-Patagónicos", 2011 ] => "2011 - Bosques Andino-Patagónicos - Neuquén",
  [ "Isla Martín García", 2011 ] => "2011 - Isla Martin Garcia - Buenos Aires",
  [ "Parque Nacional Lihué Calel", 2011 ] => "2011 - Parque Nacional Lihue Calel - La Pampa",
  [ "Precordillera de Mendoza", 2013 ] => "2013 - Precordillera Mendoza",
  [ "Reserva de Biósfera Ñacuñán", 2013 ] => "2013 - Reserva de Biósfera Ñacuñán - Mendoza",
  [ "Sierras de Córdoba", 2013 ] => "2013-2015 - Sierras de Córdoba",
  [ "Centro de Investigaciones Antonia Ramos (CIAR)", 2014 ] => "2014 - Misiones - CIAR",
  [ "Parque Nacional Iguazú", 2014 ] => "2014 - Parque Nacional Iguazú - Misiones",
  [ "Parque Nacional El Palmar", 2014 ] => "2014 - Parque Nacional el Palmar - Entre Ríos",
  [ "Reserva de Vida Silvestre Urugua-í", 2014 ] => "2014 - Reserva de Vida Silvestre Uruguaí - Misiones",
  [ "Sierras del sudoeste bonaerense", 2015 ] => "2015 - SIerras sudoeste bonaerense",
  [ "Parque Nacional Lihué Calel", 2016 ] => "2016 - Parque Nacional Lihue Calel - La Pampa",
  [ "San Luis", 2016 ] => "2016 - San Luis",
  [ "Noroeste argentino", 2017 ] => "2017 - Noroeste Argentino - Tucumán, Catamarca, La Rioja, San Juan",
  [ "Comodoro Rivadavia", 2019 ] => "2019- Comodoro Rivadavia",
  [ "Tres Cerros", 2020 ] => "2020 - Tres Cerros, Corrientes",
  [ "Parque Nacional Chaco y Parque Nacional Copo", 2021 ] => "2021 - Parque Nacional Chaco, PN Copo - Chaco, Santiago del Estero",
  [ "Parques nacionales del noroeste", 2022 ] => "2022 - Parque Nacional Calilegua, PN Aconquija, PN Los Cardones, PN Copo",
  [ "Comodoro Rivadavia", 2022 ] => "2022- Comodoro Rivadavia ",
  [ "Perú", 2023 ] => "2023 - Perú",
  [ "Río Negro y Neuquén", 2023 ] => "2023 - Río Negro y Neuquén",
  [ "Reserva Provincial Meseta de Somuncurá", 2024 ] => "2024 - Reserva Provincial Somuncurá - Río Negro",
  [ "Chubut", 2025 ] => "2025 - Chubut",
  [ "Parques nacionales y provincias del norte", 2025 ] => "2025 - PN Calilegua, PN Copo, Tucumán, Salta, Santiago del Estero"
}.freeze

DRIVE_ROOT = Rails.root.join("drive/CAMPAÑAS")

drive_index = SeedSupport.drive_index(DRIVE_ROOT)

# Hasta que llegó el material del Drive, acá había tres campañas inventadas.
# Si quedaron cargadas de una corrida anterior, se van.
Campaign.where("name LIKE ?", "#{MARK}%").destroy_all

sin_fotos = []

campaigns.each do |attributes|
  # Lihué Calel y Comodoro Rivadavia se repiten en años distintos, así que la
  # campaña se identifica por nombre + año de inicio.
  key = [ attributes[:name], attributes[:year_start] ]

  campaign = Campaign.find_or_initialize_by(name: key.first, year_start: key.last)
  campaign.update!(attributes.merge(coords_estimated: true))

  # Las fotos de campaña salen del Drive y de ningún otro lado. Si quedaron
  # placeholders de una corrida vieja, se van.
  campaign.photos.purge if campaign.photos.attached?
  next if drive_index.empty?

  folder = drive_index[SeedSupport.normalize(DRIVE_FOLDERS.fetch(key))]
  fotos = SeedSupport.photos_in(folder, limit: Campaign::EXPECTED_PHOTOS)

  if fotos.empty?
    sin_fotos << "#{key.first} (#{key.last})"
    next
  end

  fotos.each { |p| campaign.photos.attach(io: p.open, filename: p.basename.to_s) }
end

puts "Campañas: #{Campaign.count} (coordenadas aproximadas, a confirmar por el grupo)"
puts "  Fotos reales desde drive/: #{Campaign.all.count { |c| c.photos.attached? }} de #{Campaign.count}"
puts "  Sin fotos en el Drive: #{sin_fotos.join(', ')}" if sin_fotos.any?
puts "  (no existe drive/CAMPAÑAS: las campañas quedan sin fotos)" if drive_index.empty?
