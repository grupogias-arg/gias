class PostsController < ApplicationController
  def index
    @posts = Post.published.recent.with_attached_documents

    respond_to do |format|
      format.html
      # Sustituto de la suscripción por mail, que quedó para la etapa 2
      # (CLAUDE.md). Quien quiera seguir las novedades se suscribe al feed.
      format.rss { render layout: false }
    end
  end

  def show
    @post = Post.published.with_attached_documents.find_by!(slug: params[:slug])
  end
end
