# Base del panel de carga. Todo lo que cuelga de /admin pide login.
#
# El panel es solo en español: lo usa el grupo, no el público. Como /admin está
# fuera del scope de idioma de las rutas, el locale queda en el default.
class Admin::BaseController < ApplicationController
  include Authentication

  layout "admin"

  private
    # Archivo único (has_one_attached) de un formulario. Dejar vacío el campo
    # significa "no cambiar": un valor en blanco no puede borrar la foto que
    # ya estaba. Para sacarla está la casilla "Sacar"; si además se eligió un
    # archivo nuevo, gana el nuevo.
    #
    #   params.expect(member: [ :name, :photo ]).then { removing_attachment(it, :photo) }
    def removing_attachment(permitted, attachment)
      if permitted[attachment].present?
        permitted
      elsif params[:"sacar_#{attachment}"] == "1"
        permitted.merge(attachment => nil)
      else
        permitted.except(attachment)
      end
    end
end
