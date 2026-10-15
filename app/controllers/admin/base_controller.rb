# Base del panel de carga. Todo lo que cuelga de /admin pide login.
#
# El panel es solo en español: lo usa el grupo, no el público. Como /admin está
# fuera del scope de idioma de las rutas, el locale queda en el default.
class Admin::BaseController < ApplicationController
  include Authentication

  layout "admin"
end
