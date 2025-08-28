class Supporter::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :require_supporter!

  def index
    # 自分に紐づく患者を一覧表示
    @patients = current_user.patients.includes(:meal_records)
  end

  private

  def require_supporter!
    redirect_to root_path, alert: "サポーターのみ利用できます" unless current_user.supporter?
  end
end