class Campaign < ApplicationRecord
  include Translatable

  # El pedido habla de 2 fotos por campaña. Es una guía de carga, no un tope
  # duro: no se valida para no bloquear a quien sube el contenido.
  EXPECTED_PHOTOS = 2

  has_many_attached :photos do |attachable|
    attachable.variant :sm, resize_to_limit: [ 480, 360 ], format: :webp, saver: { quality: 80 }
    attachable.variant :md, resize_to_limit: [ 900, 675 ], format: :webp, saver: { quality: 80 }
    attachable.variant :lg, resize_to_limit: [ 1600, 1200 ], format: :webp, saver: { quality: 80 }
  end

  translates :name, :description

  validates :name, presence: true
  validates :lat,
            numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 },
            allow_nil: true
  validates :lng,
            numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 },
            allow_nil: true
  validates :days, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :year_start, :year_end,
            numericality: { only_integer: true, greater_than: 1900 }, allow_nil: true
  validate :coordinates_complete
  validate :year_end_not_before_year_start

  scope :mapped, -> { where.not(lat: nil).where.not(lng: nil) }
  scope :recent, -> { order(year_start: :desc, date: :desc, name: :asc) }

  def mappable? = lat.present? && lng.present?

  # Campaña de varios años ("2013–2015"), como las que vinieron del Drive.
  def multi_year? = year_end.present? && year_end != year_start

  private
    # Media coordenada no sirve para el mapa: o van las dos o ninguna.
    def coordinates_complete
      return if lat.blank? == lng.blank?

      errors.add(:base, :incomplete_coordinates)
    end

    def year_end_not_before_year_start
      return if year_start.blank? || year_end.blank?
      return if year_end >= year_start

      errors.add(:year_end, :greater_than_or_equal_to, count: year_start)
    end
end
