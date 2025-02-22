require 'rails_helper'

feature 'User can sign up', %q{
  "To ask questions
  I would like to register in the system"
} do

  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'User is trying to register' do
    fill_in 'Email', with: 'testuser@gmail.com'
    fill_in 'Password', with: 'qwerty'
    fill_in 'Password confirmation', with: 'qwerty'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
  end

  scenario 'The user enters an existing email' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'The user does not fill in the input fields' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
