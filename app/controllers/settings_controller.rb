class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    if @user.patient?
      # 連携中サポーター（1人想定の最小実装）
      @supporter = if defined?(SupportLink)
        SupportLink.includes(:supporter).find_by(patient_id: @user.id)&.supporter
      end
    else
      # サポーターの自分の招待コード
      @invite_code = if defined?(InviteCode)
        InviteCode.find_by(supporter_id: @user.id)
      end
    end
  end
end