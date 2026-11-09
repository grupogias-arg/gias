# Fotos de la portada. No hay formulario de edición: una foto se sube, se
# mueve de lugar o se borra. Para cambiarla, se borra y se sube otra.
class Admin::CoverPhotosController < Admin::BaseController
  include Admin::Reorderable
  reorders CoverPhoto, back_to: :admin_cover_photos_path

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

    first = next_position
    images.each.with_index do |image, offset|
      CoverPhoto.create!(image: image, position: first + offset)
    end

    redirect_to admin_cover_photos_path,
                notice: images.one? ? "Se agregó la foto a la portada." : "Se agregaron #{images.size} fotos a la portada."
  end

  def destroy
    CoverPhoto.find(params[:id]).destroy!
    redirect_to admin_cover_photos_path, notice: "Se sacó la foto de la portada.", status: :see_other
  end
end
