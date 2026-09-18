# Campos de contenido bilingüe.
#
# La columna base guarda el español (idioma por defecto del sitio) y el par
# `_en` es opcional. Si la traducción está vacía se muestra el español, así
# que nunca queda una página en blanco por falta de traducción (CLAUDE.md).
#
#   class Post < ApplicationRecord
#     include Translatable
#     translates :title, :excerpt, :body
#   end
#
#   post.localized_title   # => title_en con :en si está cargado, si no title
module Translatable
  extend ActiveSupport::Concern

  class_methods do
    def translates(*names)
      names.map!(&:to_sym)
      translated_attribute_names.concat(names)

      names.each do |name|
        define_method(:"localized_#{name}") { localized(name) }
      end
    end

    def translated_attribute_names
      @translated_attribute_names ||= []
    end
  end

  # Valor en el locale actual, con fallback al español.
  def localized(name)
    if I18n.locale.to_sym != I18n.default_locale.to_sym
      translation = public_send(:"#{name}_#{I18n.locale}")
      return translation if translation.present?
    end

    public_send(name)
  rescue NoMethodError
    # No hay columna para ese locale: se muestra el español.
    public_send(name)
  end
end
