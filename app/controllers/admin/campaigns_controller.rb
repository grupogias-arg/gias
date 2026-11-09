class Admin::CampaignsController < Admin::BaseController
  before_action :set_campaign, only: %i[edit update destroy]

  def index
    @campaigns = Campaign.recent.with_attached_photos
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to admin_campaigns_path, notice: "Se agregó la campaña «#{@campaign.name}»."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to admin_campaigns_path, notice: "Se guardaron los cambios de «#{@campaign.name}»."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy!
    redirect_to admin_campaigns_path, notice: "Se borró la campaña «#{@campaign.name}».", status: :see_other
  end

  private
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.expect(campaign: [ :name, :name_en, :locality, :province, :year_start, :year_end,
                                :date, :days, :description, :description_en,
                                :lat, :lng, :coords_estimated, photos: [] ])
    end
end
