FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  
  factory :user do
    email
    password { "qwerty" }
    password_confirmation { "qwerty" }
  end
end
