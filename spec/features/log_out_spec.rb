require 'rails_helper'

feature 'The user can log out of the system', %q{
  "As an authenticated user
  I would like to be able to log out"
} do

  given(:user) { create(:user) }

  scenario 'authenticated user logs out' do
    sign_in(user)

    visit questions_path
    click_on 'logout'
  end
end
