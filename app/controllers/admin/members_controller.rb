class Admin::MembersController < Admin::BaseController
  include Admin::Reorderable
  reorders Member, back_to: :admin_members_path

  before_action :set_member, only: %i[edit update destroy]

  def index
    @members = Member.ordered.with_attached_photo
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.position = next_position

    if @member.save
      redirect_to admin_members_path, notice: "Se agregó a #{@member.name} al equipo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member.update(member_params)
      redirect_to admin_members_path, notice: "Se guardaron los cambios de #{@member.name}."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member.destroy!
    redirect_to admin_members_path, notice: "Se sacó a #{@member.name} del equipo.", status: :see_other
  end

  private
    def set_member
      @member = Member.find(params[:id])
    end

    def member_params
      params.expect(member: [ :name, :rank, :rank_en, :sede, :focus, :focus_en, :bio, :bio_en,
                              :email, :conicet_url, :researchgate_url, :photo ])
            .then { removing_attachment(it, :photo) }
    end
end
