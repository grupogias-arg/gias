class Member < ApplicationRecord
  include Translatable

  has_one_attached :photo

  # `rank` es texto libre a pedido del grupo (Investigador/a, Posdoc,
  # Becario/a doctoral, Pasante), no un enum.
  translates :rank, :focus, :bio

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :conicet_url, :researchgate_url,
            format: { with: %r{\Ahttps?://}i }, allow_blank: true
  validates :position, numericality: { only_integer: true }

  scope :ordered, -> { order(:position, :name) }
end
