class Patient::HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    today = Time.zone.today

    year  = params[:year].presence&.to_i || today.year
    month = params[:month].presence&.to_i || today.month

    begin
      @month = Date.new(year, month, 1)     # 表示中の月（1日固定）
    rescue ArgumentError
      @month = today.beginning_of_month     # 不正値は今月にフォールバック
    end

    @prev_month = (@month << 1)
    @next_month = (@month >> 1)

    # ビュー用：曜日/日数など
    @first_wday = @month.wday
    @last_day   = (@month.next_month - 1).day

    @latest_comment = Comment.joins(:meal_record)
                           .where(meal_records: { patient_id: current_user.id })
                           .order(created_at: :desc)
                           .first
  end
end