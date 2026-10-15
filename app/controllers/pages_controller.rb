# La home hace scroll largo con las 8 secciones; cada sección muestra un
# adelanto y enlaza a su página propia, que es donde vive el listado completo
# (CLAUDE.md: nada importante vive solo dentro de un ancla).
class PagesController < ApplicationController
  # Cuántos registros se adelantan en la home antes del "ver todo".
  PREVIEW = 3

  def home
    @posts = Post.published.recent.with_attached_documents.limit(PREVIEW)
    @members = Member.ordered.with_attached_photo
    @publications = Publication.recent.limit(4)
    @projects = Project.recent.with_attached_photo.limit(PREVIEW)
    @campaigns = Campaign.recent.with_attached_photos.limit(PREVIEW)
    @outreach_items = OutreachItem.ordered
    @mapped_campaigns = Campaign.mapped.recent
  end

  def contact
  end
end
