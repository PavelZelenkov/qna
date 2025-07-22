require 'rails_helper'

feature 'The user can choose the best answer to the question', %q{
  "As an authenticated user
  I would like to be able to select the best answer to a question
  The best answer would then become the first one in the list
  There can only be one best answer
  Only I would like to select the best answer"
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answers) { create_list(:answer, 3, question_id: question.id, author_id: user.first.id) }

  scenario 'Authenticated user selects the best answer', js: true do # Аутентифицированный пользователь выбирает лучший ответ
    sign_in(user.first)
    visit questions_path
    click_on 'MyString'

    all(:link, 'choose the best answer')[2].click
    expect(page).to have_content 'best answer'
    # save_and_open_page
  end

  scenario 'An unauthenticated user cannot select the best answer' do # Неаутентифицированный пользователь не может выбрать лучший ответ
    visit question_path(question)

    expect(page).to_not have_link 'choose the best answer'
    expect(page).to have_content 'log in'
    expect(page).to have_content 'sign up'
    # save_and_open_page
  end

  scenario 'Only the author of the answer can choose to select the best answer' do # Только автор ответа может выбрать лучший ответ
    sign_in(user.last)
    visit question_path(question)

    expect(page).to_not have_link 'choose the best answer'
    # save_and_open_page
  end
end
