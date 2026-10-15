class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    # Borradores arriba: son los que tienen trabajo pendiente.
    @posts = Post.order(Arel.sql("published_at DESC NULLS FIRST"), created_at: :desc)
  end

  # Vista previa: la nota tal cual se va a ver en el sitio, también si todavía
  # es un borrador (la página pública solo muestra las publicadas).
  def show
    render layout: "application"
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    apply_status

    if @post.save
      redirect_to admin_posts_path, notice: saved_notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @post.assign_attributes(post_params)
    apply_status

    if @post.save
      redirect_to admin_posts_path, notice: saved_notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to admin_posts_path, notice: "Se borró «#{@post.title}».", status: :see_other
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      permitted = params.expect(post: [ :title, :title_en, :kind, :slug, :published_at,
                                        :excerpt, :excerpt_en, :body, :body_en, documents: [] ])

      # Una nota publicada ya pudo haberse compartido por WhatsApp: si cambia
      # la dirección, el link viejo deja de andar. El slug solo se edita
      # mientras es borrador.
      permitted.delete(:slug) if @post&.published_at_in_database.present?
      permitted
    end

    # El formulario tiene dos botones: "Publicar" y "Guardar como borrador".
    # La fecha solo importa al publicar: vacía es "ahora"; con una fecha
    # futura, la nota queda programada y aparece sola ese día.
    def apply_status
      case params[:estado]
      when "borrador"  then @post.published_at = nil
      when "publicada" then @post.published_at ||= Time.current
      end
    end

    def saved_notice
      case @post.status
      when :publicada  then "Se publicó «#{@post.title}»."
      when :programada then "«#{@post.title}» queda programada para el #{I18n.l(@post.published_at.to_date, format: :long)}."
      else                  "Se guardó «#{@post.title}» como borrador. Todavía no se ve en el sitio."
      end
    end
end
