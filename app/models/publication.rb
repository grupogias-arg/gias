class Publication < ApplicationRecord
  include Translatable

  KINDS = %w[cientifica divulgacion].freeze
  DOI_FORMAT = %r{\A10\.\d{4,9}/\S+\z}

  enum :kind, KINDS.index_by(&:itself), validate: true

  # El DOI siempre apunta a la editorial. El PDF es opcional: muchas revistas
  # no permiten alojar el publicado (CLAUDE.md).
  has_one_attached :pdf

  translates :title

  # Se acepta el DOI pegado como link ("https://doi.org/10…") o con prefijo
  # ("doi:10…"): se guarda solo el "10…".
  normalizes :doi, with: ->(doi) { doi.strip.sub(%r{\A(?:https?://(?:dx\.)?doi\.org/|doi:\s*)}i, "").presence }

  validates :title, presence: true
  validates :doi, uniqueness: { case_sensitive: false },
                  format: { with: DOI_FORMAT },
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
