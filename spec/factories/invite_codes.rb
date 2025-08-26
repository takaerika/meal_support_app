FactoryBot.define do
  factory :invite_code do
    association :supporter, factory: [:user, :supporter]
  end
end