class Supporter::HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # 誤って患者が来たら患者トップへ
    redirect_to root_path, alert: "患者のトップに移動しました。" and return if current_user.patient?
    # ここは当面プレースホルダ
  end
end