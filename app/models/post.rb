class Post < ApplicationRecord
  include Translatable

  KINDS = %w[divulgacion libro premio equipo publicaciones curso].freeze

  enum :kind, KINDS.index_by(&:itself), validate: true

  # El cuerpo va en Action Text, no en PDF embebido. El PDF se adjunta al pie
  # de la nota como descarga (CLAUDE.md).
  has_rich_text :body
  has_rich_text :body_en
  has_many_attached :documents

  translates :title, :excerpt, :body

  validates :title, presence: true
  validates :slug, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  before_validation :generate_slug, on: :create

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
  scope :recent, -> { order(published_at: :desc) }

  # Las novedades se comparten por WhatsApp y mail: permalink por slug.
  def to_param = slug

  # Sin fecha es un borrador; con fecha futura aparece sola ese día.
  def status
    if published_at.nil?
      :borrador
    elsif published_at.future?
      :programada
    else
      :publicada
    end
  end

  private
    def generate_slug
      return if slug.present? || title.blank?

      self.slug = title.parameterize
    end
end
