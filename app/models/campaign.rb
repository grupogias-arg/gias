class Campaign < ApplicationRecord
  include Translatable

  # El pedido habla de 2 fotos por campaña. Es una guía de carga, no un tope
  # duro: no se valida para no bloquear a quien sube el contenido.
  EXPECTED_PHOTOS = 2

  has_many_attached :photos

  translates :name, :description

  validates :name, presence: true
  validates :lat,
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 },
            allow_nil: true
  validates :lng,
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 },
            allow_nil: true
  validates :days, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :coordinates_complete

  scope :mapped, -> { where.not(lat: nil).where.not(lng: nil) }
  scope :recent, -> { order(date: :desc) }

  def mappable? = lat.present? && lng.present?

  private
    # Media coordenada no sirve para el mapa: o van las dos o ninguna.
    def coordinates_complete
      return if lat.blank? == lng.blank?

      errors.add(:base, :incomplete_coordinates)
    end
end
