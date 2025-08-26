class MealRecord < ApplicationRecord
  belongs_to :patient, class_name: "User"
  has_one_attached :photo

  enum slot: { breakfast: 0, lunch: 1, dinner: 2, snack: 3 }

  validates :eaten_on, :slot, presence: true
  validates :eaten_on, uniqueness: { scope: [:patient_id, :slot],
                                     message: "はこの区分ですでに登録されています" }
  validate  :text_or_photo_present
  validate  :photo_constraints

  private

  def text_or_photo_present
    if (text.blank? || text.strip.blank?) && !photo.attached?
      errors.add(:base, "食事内容（テキスト）または写真のいずれかは必須です")
    end
  end

  def photo_constraints
    return unless photo.attached?

    unless photo.content_type.in?(%w(image/jpeg image/png))
      errors.add(:photo, "は JPG / PNG を選択してください")
    end

    if photo.blob.byte_size.to_i > 5.megabytes
      errors.add(:photo, "は5MB以下にしてください")
    end
  end
end