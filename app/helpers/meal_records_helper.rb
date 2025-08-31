module MealRecordsHelper
  def meal_summary(record, length: 30)
    if record.text.present?
      text = truncate(record.text, length: length)
      text += " 📷" if record.photo.attached?
      text
    elsif record.photo.attached?
      "📷 写真のみ"
    else
      content_tag(:span, "（未入力）", class: "muted")
    end
  end

  def photo_badge(record)
    return "".html_safe unless record.photo.attached?
    content_tag(:span, "📷", class: "meal-has-photo", title: "写真あり", aria: { label: "写真あり" })
  end
end