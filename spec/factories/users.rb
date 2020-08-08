FactoryBot.define do
  factory :user do
    sequence(:handle_name) { |n| "allengete0#{n}" }
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name) { |n| "Boby#{n}" }
    sequence(:email) { |n| "john#{n}@live.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
