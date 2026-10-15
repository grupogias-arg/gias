# Helpers compartidos por los seeds que leen material de drive/.
#
# Se carga una sola vez desde db/seeds.rb, antes que el resto.

module SeedSupport
  module_function

  # Índice de las subcarpetas de un directorio, por nombre normalizado.
  #
  # macOS guarda los nombres de archivo con acentos en NFD ("Perú" como
  # "Peru" + combining accent) y Ruby los compara en NFC, así que buscar la
  # carpeta por igualdad directa falla con cualquier nombre acentuado.
  def drive_index(root)
    return {} unless root.directory?

    root.children
        .select(&:directory?)
        .index_by { |d| normalize(d.basename.to_s) }
  end

  def normalize(name) = name.unicode_normalize(:nfc).strip

  # Formatos que el navegador no muestra y hay que convertir.
  CONVERTIBLE = %w[.tif .tiff .heic].freeze
  WEB_FORMATS = %w[.jpg .jpeg .png .webp].freeze

  # Devuelve una ruta que el navegador pueda mostrar, convirtiendo si hace
  # falta. `sips` viene con macOS; si no está (Linux, CI) devuelve nil y la
  # foto simplemente se saltea en vez de romper el seed.
  def web_ready(path)
    return path if WEB_FORMATS.include?(path.extname.downcase)
    return nil unless CONVERTIBLE.include?(path.extname.downcase)

    converted = Rails.root.join("tmp/seed_photos", "#{path.basename(path.extname)}.jpg")
    return converted if converted.exist?

    FileUtils.mkdir_p(converted.dirname)
    ok = system("sips", "-s", "format", "jpeg", path.to_s, "--out", converted.to_s,
                out: File::NULL, err: File::NULL)
    ok && converted.exist? ? converted : nil
  end

  # Fotos de una carpeta, en orden alfabético y ya convertidas.
  #
  # El filtro va ANTES del límite: las carpetas del Drive mezclan imágenes con
  # .docx, y recortar primero puede dejar fuera la única foto que había.
  def photos_in(folder, limit: nil)
    return [] if folder.nil?

    fotos = folder.children
                  .select { |f| f.file? && (WEB_FORMATS + CONVERTIBLE).include?(f.extname.downcase) }
                  .sort
                  .filter_map { |f| web_ready(f) }

    limit ? fotos.first(limit) : fotos
  end
end
