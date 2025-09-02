class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    if @user.patient?
      @supporter = @user.supporters.first
    else
      @invite_code = @user.invite_code
    end
  end
end