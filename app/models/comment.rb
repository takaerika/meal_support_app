class Comment < ApplicationRecord
  belongs_to :meal_record
  belongs_to :user 
  validates :body, presence: true, length: { maximum: 1000 }
end