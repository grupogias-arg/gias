class PublicationsController < ApplicationController
  def index
    publications = Publication.recent.with_attached_pdf
    @cientificas = publications.select(&:cientifica?)
    @divulgacion = publications.select(&:divulgacion?)
  end
end
