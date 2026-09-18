class OutreachItem < ApplicationRecord
  include Translatable

  KINDS = %w[video playlist articulo guia actividad].freeze

  enum :kind, KINDS.index_by(&:itself), validate: true

  translates :title

  validates :title, presence: true
  validates :url, format: { with: %r{\Ahttps?://}i }, allow_blank: true
  validate :url_or_youtube_id_present

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
    def url_or_youtube_id_present
      return if url.present? || youtube_id.present?

      errors.add(:base, :url_or_youtube_id_required)
    end
end
