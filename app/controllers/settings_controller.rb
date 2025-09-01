class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    if @user.patient?
      @supporter = SupportLink.includes(:supporter).find_by(patient_id: @user.id)&.supporter
    else
      @invite_code = InviteCode.find_by(supporter_id: @user.id)
    end
  end
end