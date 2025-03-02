require 'rails_helper'

feature 'The user can write an answer to the question', %q{
  "As an authenticated user
  I would like to be able to answer the question"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  describe 'Authenticated user', js: true do
    
    background do
      sign_in(user)

      visit questions_path
      click_on 'MyString'
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'text body answer'
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_content 'text body answer'
      end
    end

    scenario 'answers question with errors' do
      click_on 'Answer'
      # save_and_open_page
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user answers a question' do
    visit questions_path
    click_on 'MyString'
    
    click_on 'Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
