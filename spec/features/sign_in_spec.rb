require 'rails_helper'

feature 'User can sign in', %q{
  "In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in"
} do

  # given(:user) { User.create!(email: 'user@test.com', password: 'qwerty') } - используем фабрику
  given(:user) { create(:user) }

  # background do
  #   visit new_user_session_path # зайти на страницу логина (visit login page)
  # end
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email # заполнить два поля - email, password
    fill_in 'Password', with: user.password
    click_on 'Log in'

    # save_and_open_page - проверка что происходит на странице (gem 'launchy' ставится в группу тесты)
    expect(page).to have_content 'Signed in successfully.' # ожидание, что мы хотим получить
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com' # заполнить два поля - email, password
    fill_in 'Password', with: 'qwerty'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
