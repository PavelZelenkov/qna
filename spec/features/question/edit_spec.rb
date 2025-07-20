require 'rails_helper'

feature 'User can edit his question', %q{
  "In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question"
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    # save_and_open_page
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit question'

      within'.questions' do
        fill_in 'Your question title', with: 'edited question title'
        fill_in 'Your question body', with: 'edited question body'
        click_on 'Save'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textarea'
      end
      # save_and_open_page
    end

    scenario 'edits his question with errors', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit question'

      within'.questions' do
        fill_in 'Your question title', with: ''
        fill_in 'Your question body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
      # save_and_open_page
    end

    scenario "tries to edit other user's question" do
      sign_in(user.last)
      visit questions_path
      click_on 'MyString'
      expect(page).to_not have_link 'Edit'
      # save_and_open_page
    end
  end
end