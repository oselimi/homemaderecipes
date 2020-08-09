FactoryBot.define do
  factory :ingredient do
    amount { "250ml milk" }
    user { nil }
    recipe { nil }
  end
end
