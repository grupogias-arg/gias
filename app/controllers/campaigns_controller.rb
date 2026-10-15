class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.recent.with_attached_photos
    @mapped_campaigns = @campaigns.select(&:mappable?)
  end
end
