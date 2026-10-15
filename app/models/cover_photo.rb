# Fotos que rotan en la portada, al lado del logo fijo (docs/pedido.md:
# "imágenes rotatorias, y que el logo quede fijo").
#
# El grupo mandó fotos de estudio, con la araña sobre fondo blanco. La vista
# las funde con el papel del sitio (mix-blend-multiply), así que el blanco no
# se ve como un recuadro. Una foto de campo, con fondo propio, se vería
# recortada en rectángulo: para eso están Campañas y las novedades.
class CoverPhoto < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :sm, resize_to_limit: [ 480, 360 ], format: :webp, saver: { quality: 80 }
    attachable.variant :md, resize_to_limit: [ 900, 675 ], format: :webp, saver: { quality: 80 }
    attachable.variant :lg, resize_to_limit: [ 1600, 1200 ], format: :webp, saver: { quality: 80 }
  end

  validates :image, presence: true
  validates :position, numericality: { only_integer: true }

  scope :ordered, -> { order(:position, :id) }
end
