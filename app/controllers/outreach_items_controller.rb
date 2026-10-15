class OutreachItemsController < ApplicationController
  def index
    items = OutreachItem.ordered
    @videos = items.select(&:embedded_video?)
    @materiales = items.reject(&:embedded_video?)
  end
end
