FactoryBot.define do
  factory :comment do
    body { "MyText" }
    association :user
    association :commentable, factory: :question
  end
end
