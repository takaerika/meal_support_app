class SupportLink < ApplicationRecord
  belongs_to :supporter, class_name: "User"
  belongs_to :patient,   class_name: "User"
  validates :supporter_id, uniqueness: { scope: :patient_id }
end