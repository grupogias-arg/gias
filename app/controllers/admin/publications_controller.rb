class Admin::PublicationsController < Admin::BaseController
  before_action :set_publication, only: %i[edit update destroy]

  def index
    @publications = Publication.recent.with_attached_pdf
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = Publication.new(publication_params)

    if @publication.save
      redirect_to admin_publications_path, notice: "Se agregó «#{@publication.title}»."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @publication.update(publication_params)
      redirect_to admin_publications_path, notice: "Se guardaron los cambios de «#{@publication.title}»."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @publication.destroy!
    redirect_to admin_publications_path, notice: "Se borró «#{@publication.title}».", status: :see_other
  end

  private
    def set_publication
      @publication = Publication.find(params[:id])
    end

    def publication_params
      params.expect(publication: [ :kind, :title, :title_en, :authors, :year, :journal, :doi, :pdf ])
            .then { removing_attachment(it, :pdf) }
    end
end
