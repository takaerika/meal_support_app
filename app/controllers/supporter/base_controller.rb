class Supporter::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_supporter!

  private

  def require_supporter!
    return if current_user&.supporter?
    redirect_to root_path, alert: "サポーターのみ利用できます"
  end
end