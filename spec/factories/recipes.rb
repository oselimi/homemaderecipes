FactoryBot.define do
  factory :recipe do
    title { "Title of recipe" }
    description { "the description of recipes" }
    user { nil }
  end
end
