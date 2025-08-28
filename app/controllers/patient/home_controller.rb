class Patient::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!

  def index
    today = Date.today
    year  = params[:year].presence&.to_i || today.year
    month = params[:month].presence&.to_i || today.month
    @month = Date.new(year, month, 1)

    @prev_month = @month << 1
    @next_month = @month >> 1
    @first_wday = @month.wday
    @last_day   = (@month.next_month - 1).day

    # 新着コメントを患者トップに表示するならここで
    @latest_comment = current_user.meal_records.joins(:comments)
                           .order("comments.created_at DESC").first&.comments&.last
  end

  private

  def ensure_patient!
    redirect_to supporter_home_path, alert: "患者のみ利用できます" if current_user.supporter?
  end
end