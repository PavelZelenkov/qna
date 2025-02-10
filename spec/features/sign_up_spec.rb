require 'rails_helper'

feature 'User can sign up', %q{
  "To ask questions
  I would like to register in the system"
} do

  scenario 'User is trying to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'usertest@gmail.com'
    fill_in 'Password', with: 'qwerty'
    fill_in 'Password confirmation', with: 'qwerty'
    click_on 'Sign up'
    # save_and_open_page
  end
end
