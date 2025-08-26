class MealRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!
  before_action :set_record, only: [:show, :edit, :update]

  def index
    @date = safe_date(params[:date]) || Date.current
    @records = current_user.meal_records
                  .where(eaten_on: @date)
                  .order(slot: :asc)
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
    @record = current_user.meal_records.find(params[:id])
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