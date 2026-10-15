# Datos de contacto y redes, desde config/site.yml.
#
# Las claves vacías se descartan para que la
# vista muestre solo lo que existe de verdad.
Rails.application.config.site = Rails.application
  .config_for(:site)
  .to_h
  .compact_blank
