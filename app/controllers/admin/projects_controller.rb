class Admin::ProjectsController < Admin::BaseController
  before_action :set_project, only: %i[edit update destroy]

  def index
    @projects = Project.recent.with_attached_photo
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to admin_projects_path, notice: "Se agregó «#{@project.title}»."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to admin_projects_path, notice: "Se guardaron los cambios de «#{@project.title}»."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy!
    redirect_to admin_projects_path, notice: "Se borró «#{@project.title}».", status: :see_other
  end

  private
    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.expect(project: [ :title, :title_en, :funder, :year_start, :year_end,
                               :description, :description_en, :photo ])
            .then { removing_attachment(it, :photo) }
    end
end
