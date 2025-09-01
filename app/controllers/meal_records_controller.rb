# app/controllers/meal_records_controller.rb
class MealRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_patient!, except: [:show]
  before_action :set_record, only: [:show, :edit, :update]
  before_action :set_date!, only: [:index, :new]

  # GET /meal_records?date=YYYY-MM-DD
  def index
    @records = current_user.meal_records
                           .where(eaten_on: @date)
                           .order(:slot)
  end

  # GET /meal_records/new?date=YYYY-MM-DD
  def new
    @record = current_user.meal_records.new(eaten_on: @date)
  end

  # POST /meal_records
  def create
    @record = current_user.meal_records.new(record_params.except(:remove_photo))
    if @record.save
      redirect_to @record, notice: "食事記録を登録しました"
    else
      flash.now[:alert] = "保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end
  
  def update
    if record_params[:remove_photo] == "1"
      @record.photo.purge_later
    end

    if @record.update(record_params.except(:remove_photo))
      redirect_to @record, notice: "食事記録を更新しました"
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_date!
    if params[:date].blank?
      redirect_to root_path, alert: "日付を指定してください" and return
    end

    @date = safe_date(params[:date])
    unless @date
      redirect_to root_path, alert: "日付の形式が不正です" and return
    end
  end

  def set_record
    @record = MealRecord.find(params[:id])

   
    allowed =
      (@record.patient_id == current_user.id) ||
      (current_user.supporter? && current_user.patients.exists?(@record.patient_id))

    redirect_to root_path, alert: "アクセス権限がありません" and return unless allowed
  end

  
  def ensure_patient!
    if current_user.supporter?
      redirect_to supporter_home_path, alert: "患者のみ利用できます"
    end
  end

  def record_params
    params.require(:meal_record).permit(:eaten_on, :slot, :text, :note, :photo, :remove_photo)
  end

  def safe_date(str)
    Date.strptime(str, "%Y-%m-%d")
  rescue ArgumentError, TypeError
    nil
  end
end