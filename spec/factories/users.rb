FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password   { "password" }
    first_name { "太郎" }
    last_name  { "山田" }
    role       { :patient }

    trait :supporter do
      role       { :supporter }
      first_name { "花子" }
      last_name  { "佐藤" }
    end
  end
end