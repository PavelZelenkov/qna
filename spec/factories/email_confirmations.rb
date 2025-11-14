FactoryBot.define do
  factory :email_confirmation do
    user { nil }
    token { "MyString" }
    confirmed { false }
  end
end
