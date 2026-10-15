# =============================================================================
# PORTADA — fotos REALES, de drive/PORTADA/
# =============================================================================
#
# Son las candidatas que mandó el grupo: arañas de estudio sobre fondo blanco.
# Entran todas, en el orden numérico de los archivos (1, 2, … 16); desde el
# panel (/admin/portada) se reordenan o se sacan.
#
# `ejemplo_portada.png` no es una foto: es el boceto del grupo de cómo se
# imaginan la portada (logo fijo y la foto al lado). Se saltea.
#
# Solo carga si la portada está vacía, para no pisar lo que el grupo haya
# cambiado desde el panel.
# =============================================================================

if CoverPhoto.none?
  carpeta = Rails.root.join("drive/PORTADA")
  fotos = SeedSupport.photos_in(carpeta.directory? ? carpeta : nil)
                     .reject { |path| path.basename.to_s.start_with?("ejemplo") }
                     .sort_by { |path| [ path.basename.to_s.to_i, path.basename.to_s ] }

  fotos.each.with_index(1) do |path, position|
    CoverPhoto.create!(position: position,
                       image: { io: path.open, filename: path.basename.to_s.downcase })
  end
end
