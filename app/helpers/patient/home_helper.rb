module Patient::HomeHelper
  # 前月/翌月のクエリを組み立て
  def month_path(date)
    root_path(month: date.strftime("%Y-%m-01"))
  end

  # 曜日（日本語）
  def wday_ja(date)
    %w[日 月 火 水 木 金 土][date.wday]
  end
end