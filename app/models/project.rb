class Project < ApplicationRecord
  include Translatable

  FUNDERS = %w[pict rufford pnud otros].freeze

  enum :funder, FUNDERS.index_by(&:itself), validate: true

  has_one_attached :photo do |attachable|
    attachable.variant :sm, resize_to_limit: [ 480, 360 ], format: :webp, saver: { quality: 80 }
    attachable.variant :md, resize_to_limit: [ 900, 675 ], format: :webp, saver: { quality: 80 }
    attachable.variant :lg, resize_to_limit: [ 1600, 1200 ], format: :webp, saver: { quality: 80 }
  end

  translates :title, :description

  validates :title, presence: true
  validates :year_start, :year_end,
            numericality: { only_integer: true, greater_than: 1900 }, allow_nil: true
  validate :year_end_not_before_year_start

  scope :recent, -> { order(year_start: :desc, title: :asc) }

  # Proyecto en curso: sin año de cierre.
  def ongoing? = year_end.blank?

  private
    def year_end_not_before_year_start
      return if year_start.blank? || year_end.blank?
      return if year_end >= year_start

      errors.add(:year_end, :greater_than_or_equal_to, count: year_start)
    end
end
