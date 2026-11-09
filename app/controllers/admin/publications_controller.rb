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

  # Lo pide el botón "Traer datos" (crossref_controller.js). Responde JSON con
  # los datos del trabajo o con un mensaje para mostrar al lado del botón.
  def crossref
    doi = Publication.normalize_value_for(:doi, params[:doi].to_s)

    if doi.blank? || !doi.match?(Publication::DOI_FORMAT)
      render json: { error: "Eso no parece un DOI. Tiene que empezar con «10.», por ejemplo 10.1234/abcd.5678." },
             status: :unprocessable_entity
    elsif (existing = Publication.where.not(id: params[:id]).find_by("LOWER(doi) = ?", doi.downcase))
      render json: { error: "Ese DOI ya está cargado: «#{existing.title}».", edit_url: edit_admin_publication_path(existing) },
             status: :conflict
    elsif (work = Crossref.work(doi))
      render json: work
    else
      render json: { error: "Crossref no conoce ese DOI. Revisá que esté bien copiado, o completá los datos a mano." },
             status: :not_found
    end
  rescue Crossref::Error => error
    Rails.logger.warn("[crossref] #{error.message}")
    render json: { error: "No se pudo consultar Crossref en este momento. Probá de nuevo en un rato o completá los datos a mano." },
           status: :bad_gateway
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
