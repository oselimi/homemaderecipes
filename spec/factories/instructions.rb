FactoryBot.define do
  factory :instruction do
    sequence(:step) {|n| "First step#{n}" }
    sequence(:body) {|n| "Add instruction of your recipe#{n}" }
    recipe { nil }
    user { nil }
  end
end
