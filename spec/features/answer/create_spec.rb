require 'rails_helper'

feature 'The user can write an answer to the question', %q{
  "As an authenticated user
  I would like to be able to answer the question"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question_id: question.id)}

  scenario 'An authenticated user answers a question' do
    sign_in(user)

    visit questions_path
    click_on 'MyString' # перейти на страницу вопроса
    # save_and_open_page
    fill_in 'Body', with: 'text answer'
    click_on 'Answer' # написать ответ на вопрос
    expect(page).to have_content 'text answer'
    # save_and_open_page
  end

  # scenario 'Authenticated user answers question with errors' do
  #   sign_in(user)

  #   visit questions_path
  #   click_on 'MyString' # перейти на страницу вопроса
    
  #   # save_and_open_page
  #   click_on 'Answer' # написать ответ на вопрос
  #   save_and_open_page
  #   expect(page).to have_content 'text answer'
  #   # save_and_open_page
  # end

  # scenario 'Unauthenticated user answers a question'

end
