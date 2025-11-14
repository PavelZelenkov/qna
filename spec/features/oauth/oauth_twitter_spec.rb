require 'rails_helper'

feature 'Twitter OAuth', js: true do
  background do
    mock_auth_hash
    User.create!(email: 'twitter@test.com', password: 'qwerty', confirmed: true)
    visit new_user_session_path
  end

  scenario 'User signs in with Twitter successfully' do
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Signed in successfully').or have_content('Twitter')
  end

  scenario 'Omniauth authentication error handled' do
    mock_auth_error
    visit new_user_session_path
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Could not authenticate you from Twitter')
  end

  scenario 'Prompts for email if not provided' do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123545',
      info: { email: nil }
    })
    visit new_user_session_path
    click_link 'Sign in with Twitter'
    expect(page).to have_current_path(new_email_confirmation_path)
    expect(page).to have_content('Enter your Email to complete registration')
  end
end
