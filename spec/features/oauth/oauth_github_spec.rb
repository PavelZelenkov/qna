require 'rails_helper'

feature 'GitHub OAuth', js: true do
  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123',
      info: {
        email: 'github@test.com'
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
    User.create!(email: 'github@test.com', password: 'qwerty', confirmed: true)
    visit new_user_session_path
  end

  scenario 'User signs in with GitHub successfully' do
    click_link 'Sign in with GitHub'
    expect(page).to have_content('Successfully authenticated from GitHub account.')
  end

  scenario 'GitHub OAuth authentication error handled' do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    visit new_user_session_path
    click_link 'Sign in with GitHub'
    expect(page).to have_content('Could not authenticate you from GitHub')
  end

  scenario 'Prompts for email if not provided' do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '124',
      info: { email: nil }
    )
    visit new_user_session_path
    click_link 'Sign in with GitHub'
    expect(page).to have_current_path(new_email_confirmation_path)
    expect(page).to have_content('Enter your Email to complete registration')
  end
end
