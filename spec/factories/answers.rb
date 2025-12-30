FactoryBot.define do
  sequence :body do |n|
    "MyStringAnswer #{n}"
  end
  
  factory :answer do
    body
    question

    association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
