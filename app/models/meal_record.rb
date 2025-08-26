class MealRecord < ApplicationRecord
  belongs_to :patient, class_name: "User"

  enum slot: { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }

  validates :eaten_on, :slot, presence: true
  validates :eaten_on, uniqueness: { scope: [:patient_id, :slot],
                                     message: "はこの区分ですでに登録されています" }

  # MVP: textが空でも保存OK（後で「写真 or テキスト必須」に引き上げ）
  # 将来: ActiveStorage導入後に custom validate で "textまたはphotoどちらか必須" にする
end