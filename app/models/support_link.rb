class SupportLink < ApplicationRecord
  belongs_to :supporter, class_name: "User"
  belongs_to :patient,   class_name: "User"

  scope :alive, -> { where(deleted_at: nil) }

  validates :supporter_id, presence: true
  validates :patient_id,   presence: true
  validates :patient_id, uniqueness: { scope: :supporter_id, conditions: -> { where(deleted_at: nil) } }
end