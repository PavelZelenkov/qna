FactoryBot.define do
  factory :answer do
    body { "MyStringAnswer" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
