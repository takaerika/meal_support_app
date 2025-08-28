class Supporter::PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_supporter!
  before_action :set_patient

  def show
    today = Date.today
    year  = params[:year].presence&.to_i || today.year
    month = params[:month].presence&.to_i || today.month
    @month = Date.new(year, month, 1)

    @prev_month = @month << 1
    @next_month = @month >> 1
    @first_wday = @month.wday
    @last_day   = (@month.next_month - 1).day

    # 指定日の食事記録一覧
    @date = params[:date].present? ? Date.parse(params[:date]) : today
    @records = @patient.meal_records.where(eaten_on: @date).order(:slot)
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end

  def require_supporter!
    redirect_to root_path, alert: "サポーターのみ利用できます" unless current_user.supporter?
  end
end