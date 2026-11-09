class OutreachItem < ApplicationRecord
  include Translatable

  KINDS = %w[video playlist articulo guia actividad].freeze

  enum :kind, KINDS.index_by(&:itself), validate: true

  translates :title

  validates :title, presence: true
  validates :url, format: { with: %r{\Ahttps?://\S+\z}i }, allow_blank: true
  validates :youtube_id, format: { with: /\A[\w-]+\z/ }, allow_blank: true
  validate :url_or_youtube_id_present

  # En el panel se pega el link del video tal cual lo da YouTube, no el ID.
  before_validation :extract_youtube_id

  scope :ordered, -> { order(:position, :title) }
  scope :videos, -> { where(kind: %w[video playlist]) }

  def embedded_video? = video? || playlist?

  # youtube-nocookie + carga diferida: son 6+ videos y la página se ve
  # sobre todo desde el celular (CLAUDE.md).
  def youtube_embed_url
    return if youtube_id.blank?

    if playlist?
      "https://www.youtube-nocookie.com/embed/videoseries?list=#{youtube_id}"
    else
      "https://www.youtube-nocookie.com/embed/#{youtube_id}"
    end
  end

  private
    # Acepta youtube.com/watch?v=…, youtu.be/…, /shorts/…, /embed/… y, para
    # las listas, cualquier link con ?list=…. Un ID suelto queda como está.
    def extract_youtube_id
      value = youtube_id.to_s.strip
      self.youtube_id = value.presence
      return unless value.include?("/")

      uri = URI.parse(value)
      query = Rack::Utils.parse_query(uri.query)

      self.youtube_id = playlist? ? query["list"] : (query["v"] || uri.path.split("/").last)
    rescue URI::InvalidURIError
      # Queda el texto pegado y la validación de formato avisa.
    end

    def url_or_youtube_id_present
      return if url.present? || youtube_id.present?

      errors.add(:base, :url_or_youtube_id_required)
    end
end
