class MembersController < ApplicationController
  def index
    @members = Member.ordered.with_attached_photo
  end
end
