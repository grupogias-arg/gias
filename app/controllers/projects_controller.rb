class ProjectsController < ApplicationController
  def index
    @projects = Project.recent.with_attached_photo
  end
end
