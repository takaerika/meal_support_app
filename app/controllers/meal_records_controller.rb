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

  # GET /meal_records/:id
  def show
    # @record は set_record で取得＆権限チェック済み
  end

  # GET /meal_records/:id/edit
  def edit
    # @record は set_record 済み（患者のみ到達）
  end

  # PATCH/PUT /meal_records/:id
  def update
    # remove_photo の処理（チェックありなら先に削除）
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

  # /meal_records で日付が必須。無い/不正ならトップへ
  def set_date!
    if params[:date].blank?
      redirect_to root_path, alert: "日付を指定してください" and return
    end

    @date = safe_date(params[:date])
    unless @date
      redirect_to root_path, alert: "日付の形式が不正です" and return
    end
  end

  # :show/:edit/:update 用の取得と権限チェック
  def set_record
    @record = MealRecord.find(params[:id])

    # 自分の記録 もしくは 自分が担当サポーターの患者の記録のみ閲覧可
    allowed =
      (@record.patient_id == current_user.id) ||
      (current_user.supporter? && current_user.patients.exists?(@record.patient_id))

    redirect_to root_path, alert: "アクセス権限がありません" and return unless allowed
  end

  # サポーターは index/new/create/edit/update へ来られない
  def ensure_patient!
    if current_user.supporter?
      redirect_to supporter_home_path, alert: "患者のみ利用できます"
    end
  end

  def record_params
    params.require(:meal_record).permit(:eaten_on, :slot, :text, :note, :photo, :remove_photo)
  end

  # "2025-08-26" 形式のみ許可
  def safe_date(str)
    Date.strptime(str, "%Y-%m-%d")
  rescue ArgumentError, TypeError
    nil
  end
end