FactoryBot.define do
  factory :meal_record do
    association :patient, factory: :user
    eaten_on { Date.current }
    slot     { :breakfast }
    text     { "ごはん、味噌汁、焼き魚" }
    note     { "外食" }
  end
end