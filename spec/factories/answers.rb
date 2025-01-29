FactoryBot.define do
  factory :answer do
    body { "MyString" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
