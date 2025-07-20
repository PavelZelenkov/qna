require 'rails_helper'

feature 'User can edit his answer', %q{
  "In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer"
} do

  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: :true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit'

      within'.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      sign_in(user.last)
      visit questions_path
      click_on 'MyString'
      expect(page).to_not have_link 'Edit'
    end
  end
end
