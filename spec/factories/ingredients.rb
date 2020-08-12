FactoryBot.define do
  factory :ingredient do
    sequence(:amount) {|n| "250ml milk#{n}" }
    user { nil }
    recipe { nil }
  end
end
