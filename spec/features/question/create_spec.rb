require 'rails_helper'

feature 'User can create question', %q{
  "In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question"
} do
  
  # given(:user) { User.create!(email: 'user@test.com', password: 'qwerty') } - используем фабрику
  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do # выносим в бекграунд посещение входа на сайт, ввода логина, пароля и нажатия кнопки "Log in"
      sign_in(user)
      # visit new_user_session_path - из бекграунда данный перечень команд улетел в support/feature_helpers
      # fill_in 'Email', with: user.email
      # fill_in 'Password', with: user.password
      # click_on 'Log in'

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      # visit new_user_session_path - вынесли в бекграунд
      # fill_in 'Email', with: user.email
      # fill_in 'Password', with: user.password
      # click_on 'Log in'

      # visit questions_path - вынесли в бекграунд
      # click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question soccessfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors' do
      # visit new_user_session_path - вынесли в бекграунд
      # fill_in 'Email', with: user.email
      # fill_in 'Password', with: user.password
      # click_on 'Log in'

      # visit questions_path - вынесли в бекграунд
      # click_on 'Ask question'

      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
