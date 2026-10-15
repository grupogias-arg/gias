# Fotos de la portada. No hay formulario de edición: una foto se sube, se
# mueve de lugar o se borra. Para cambiarla, se borra y se sube otra.
class Admin::CoverPhotosController < Admin::BaseController
  def index
    @cover_photos = CoverPhoto.ordered.with_attached_image
  end

  # Se pueden elegir varias fotos de una vez; cada una es un registro, y entran
  # al final de la rotación.
  def create
    images = Array(params.dig(:cover_photo, :images)).compact_blank

    if images.empty?
      redirect_to admin_cover_photos_path, alert: "Elegí al menos una foto para subir."
      return
    end

    last = CoverPhoto.maximum(:position) || 0
    images.each.with_index(1) do |image, offset|
      CoverPhoto.create!(image: image, position: last + offset)
    end

    redirect_to admin_cover_photos_path,
                notice: images.one? ? "Se agregó la foto a la portada." : "Se agregaron #{images.size} fotos a la portada."
  end

  # Flechas "antes" / "después": intercambia la foto con su vecina. Antes se
  # renumera todo, por si quedaron posiciones repetidas o salteadas.
  def move
    photos = CoverPhoto.ordered.to_a
    index = photos.index { |photo| photo.id == params[:id].to_i }
    target = params[:direction] == "antes" ? index - 1 : index + 1

    if index && target.between?(0, photos.size - 1)
      photos[index], photos[target] = photos[target], photos[index]

      CoverPhoto.transaction do
        photos.each.with_index(1) { |photo, position| photo.update_column(:position, position) }
      end
    end

    redirect_to admin_cover_photos_path, status: :see_other
  end

  def destroy
    CoverPhoto.find(params[:id]).destroy!
    redirect_to admin_cover_photos_path, notice: "Se sacó la foto de la portada.", status: :see_other
  end
end
