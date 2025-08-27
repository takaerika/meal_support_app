FactoryBot.define do
  factory :comment do
    meal_record { nil }
    user { nil }
    body { "MyText" }
  end
end
