require 'rails_helper'

feature 'The user can write an answer to the question', %q{
  "As an authenticated user
  I would like to be able to answer the question"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  # given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  describe 'Authenticated user' do
    
    background do
      sign_in(user)

      visit questions_path
      click_on 'MyString' # перейти на страницу вопроса
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'text body answer'
      click_on 'Answer' # написать ответ на вопрос
      expect(page).to have_content 'text body answer'
      # save_and_open_page
    end

    scenario 'answers question with errors' do
      click_on 'Answer' # написать ответ на вопрос
      expect(page).to have_content 'error creating answer to question'
      # save_and_open_page
    end
  end

  scenario 'Unauthenticated user answers a question' do
    visit questions_path
    click_on 'MyString' # перейти на страницу вопроса
    
    click_on 'Answer' # написать ответ на вопрос
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
