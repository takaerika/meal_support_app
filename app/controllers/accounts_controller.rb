class AccountsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    current_user.update!(deleted_at: Time.current)

    sign_out current_user
    redirect_to root_path, notice: "退会が完了しました。ご利用ありがとうございました。"
  end
end
