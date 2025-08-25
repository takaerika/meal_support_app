class Patient::HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # サポーターは後で専用ページへ。今は簡易にメッセージで返す
    if current_user.supporter?
       redirect_to supporter_home_path and return
    end

    # 表示する月（?month=2025-08 のように切替可）
    @month = params[:month].present? ? Date.parse(params[:month]) : Time.zone.today.beginning_of_month

    # 1日〜末日までを配列で
    @days = (@month..@month.end_of_month).to_a

    # （未実装でも安全）未読コメントのある日、直近更新日などのダミー
    @unread_comment_days = [] # 例: [Date.new(2025,8,20)]
    @today = Time.zone.today

    # サポーター表示用（SupportLink 実装後に置き換え）
    @supporter_name = nil
    if defined?(SupportLink)
      supporter = SupportLink.includes(:supporter).find_by(patient_id: current_user.id)&.supporter
      @supporter_name = "#{supporter&.last_name} #{supporter&.first_name}" if supporter
    end

    # 直近更新日（MealRecord 実装後に置き換え）
    @last_update_date =
      if defined?(MealRecord)
        MealRecord.where(patient_id: current_user.id).maximum(:created_at)&.to_date
      end
  end
end