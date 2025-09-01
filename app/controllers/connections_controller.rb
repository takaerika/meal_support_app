class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def create
    return redirect_to settings_path, alert: "患者のみ操作できます" unless current_user.patient?

    code = params[:code].to_s.strip.upcase
    supporter = InviteCode.includes(:supporter).find_by(code: code)&.supporter
    return redirect_to settings_path, alert: "コードが正しくありません" unless supporter

    SupportLink.find_or_create_by!(supporter: supporter, patient: current_user)
    redirect_to settings_path, notice: "サポーターと連携しました"
  end

  def destroy
    return redirect_to settings_path, alert: "患者のみ操作できます" unless current_user.patient?
    SupportLink.where(patient_id: current_user.id).delete_all
    redirect_to settings_path, notice: "サポーターとの連携を解除しました"
  end
end