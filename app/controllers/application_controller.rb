class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  around_action :switch_locale

  private
    # El español no lleva prefijo en la URL, el inglés sí (/en/equipo).
    def switch_locale(&)
      I18n.with_locale(params[:locale] || I18n.default_locale, &)
    end

    # Que todos los link_to conserven el idioma sin pasarlo a mano en cada vista.
    def default_url_options
      I18n.locale == I18n.default_locale ? {} : { locale: I18n.locale }
    end
end
