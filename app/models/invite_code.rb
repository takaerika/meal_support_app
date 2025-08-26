class InviteCode < ApplicationRecord
  belongs_to :supporter, class_name: "User"
  validates :code, presence: true, uniqueness: true
end