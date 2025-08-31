class MealRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!, except: [:show]
  before_action :set_record, only: [:show, :edit, :update]

  def index
  @patient = current_user  

  if params[:date].present?
    # 日別表示
    @date = safe_date(params[:date]) || Date.current
    @records = @patient.meal_records.where(eaten_on: @date).order(:slot)
  else
    # 月別表示
    today = Date.today
    year  = params[:year].presence&.to_i || today.year
    month = params[:month].presence&.to_i || today.month
    @month = Date.new(year, month, 1)

    @prev_month = @month << 1
    @next_month = @month >> 1
    @first_wday = @month.wday
    @last_day   = (@month.next_month - 1).day

    @records = @patient.meal_records
                       .where(eaten_on: @month..@month.end_of_month)
                       .order(:eaten_on, :slot)
    end
  end

  def new
    default_date = safe_date(params[:date]) || Date.current
    @record = current_user.meal_records.new(eaten_on: default_date)
  end

  def create
    @record = current_user.meal_records.new(record_params)
    if @record.save
      redirect_to @record, notice: "食事記録を登録しました"
    else
      flash.now[:alert] = "保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @record = current_user.meal_records.find(params[:id])
    if params[:meal_record][:remove_photo] == "1"
      @record.photo.purge
    end

    if @record.update(record_params.except(:remove_photo))
      redirect_to @record, notice: "食事記録を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_record
    @record = MealRecord.find(params[:id])

    unless @record.patient == current_user ||
         (current_user.supporter? && current_user.patients.include?(@record.patient))
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end

  def ensure_patient!
    redirect_to supporter_home_path, alert: "患者のみ利用できます" if current_user.supporter?
  end

  def record_params
    params.require(:meal_record).permit(:eaten_on, :slot, :text, :note, :photo, :remove_photo)
  end

  # "2025-08-26" 形式のみ許可して安全にパース
  def safe_date(str)
    return nil if str.blank?
    Date.strptime(str, "%Y-%m-%d")
  rescue ArgumentError
    nil
  end
end