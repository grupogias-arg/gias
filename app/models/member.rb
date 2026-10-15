class Member < ApplicationRecord
  include Translatable

  # Variantes para srcset: la foto original puede venir de cámara y pesar
  # varios MB, y el celular no tiene que bajar eso (CLAUDE.md).
  has_one_attached :photo do |attachable|
    attachable.variant :sm, resize_to_limit: [ 320, 400 ], format: :webp, saver: { quality: 80 }
    attachable.variant :md, resize_to_limit: [ 640, 800 ], format: :webp, saver: { quality: 80 }
    attachable.variant :lg, resize_to_limit: [ 960, 1200 ], format: :webp, saver: { quality: 80 }
  end

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
