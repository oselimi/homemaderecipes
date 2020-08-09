FactoryBot.define do
  factory :instruction do
    step { "First step" }
    body { "Add instruction of your recipe" }
    recipe { nil }
    user { nil }
  end
end
