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

    @records = current_user.meal_records.where(eaten_on: @month..@month.end_of_month)
    window_from = Time.zone.now - 24.hours  # 期間制限しないならこの行は不要
    @latest_comment =
    Comment.joins(:meal_record)
           .where(meal_records: { patient_id: current_user.id })
           # .where('comments.created_at >= ?', window_from)  # ←24h以内だけなら有効化
           .order(created_at: :desc)
           .first
  end

  private

  def ensure_patient!
    redirect_to supporter_home_path, alert: "患者のみ利用できます" if current_user.supporter?
  end
end