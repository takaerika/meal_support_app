FactoryBot.define do
  factory :support_link do
    association :supporter, factory: [:user, :supporter]
    association :patient,   factory: :user
  end
end