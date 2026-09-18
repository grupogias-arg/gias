class Publication < ApplicationRecord
  include Translatable

  KINDS = %w[cientifica divulgacion].freeze

  enum :kind, KINDS.index_by(&:itself), validate: true

  # El DOI siempre apunta a la editorial. El PDF es opcional: muchas revistas
  # no permiten alojar el publicado (CLAUDE.md).
  has_one_attached :pdf

  translates :title

  validates :title, presence: true
  validates :doi, uniqueness: { case_sensitive: false },
                  format: { with: %r{\A10\.\d{4,9}/\S+\z} },
                  allow_blank: true
  validates :doi, presence: true, if: :cientifica?
  validates :year,
            numericality: {
              only_integer: true,
              greater_than: 1900,
              less_than_or_equal_to: ->(_publication) { Date.current.year + 1 }
            },
            allow_nil: true

  scope :recent, -> { order(year: :desc, title: :asc) }

  def doi_url = doi.presence && "https://doi.org/#{doi}"
end
