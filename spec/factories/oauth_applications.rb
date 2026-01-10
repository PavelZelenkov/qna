FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { "Test" }
    redirect_uri { "https://localhost:3000/oauth/callback" }
    uid { "12345678" }
    secret { "1234567890" }
  end
end
