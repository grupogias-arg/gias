class Admin::OutreachItemsController < Admin::BaseController
  include Admin::Reorderable
  reorders OutreachItem, back_to: :admin_outreach_items_path

  before_action :set_outreach_item, only: %i[edit update destroy]

  def index
    @outreach_items = OutreachItem.ordered
  end

  def new
    @outreach_item = OutreachItem.new
  end

  def create
    @outreach_item = OutreachItem.new(outreach_item_params)
    @outreach_item.position = next_position

    if @outreach_item.save
      redirect_to admin_outreach_items_path, notice: "Se agregó «#{@outreach_item.title}»."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @outreach_item.update(outreach_item_params)
      redirect_to admin_outreach_items_path, notice: "Se guardaron los cambios de «#{@outreach_item.title}»."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @outreach_item.destroy!
    redirect_to admin_outreach_items_path, notice: "Se borró «#{@outreach_item.title}».", status: :see_other
  end

  private
    def set_outreach_item
      @outreach_item = OutreachItem.find(params[:id])
    end

    def outreach_item_params
      params.expect(outreach_item: [ :kind, :title, :title_en, :authors, :url, :youtube_id ])
    end
end
