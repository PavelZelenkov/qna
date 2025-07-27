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

    background do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit question'
    end

    scenario 'edits his question', js: true do
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
      within'.questions' do
        fill_in 'Your question title', with: ''
        fill_in 'Your question body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
      # save_and_open_page
    end

    scenario 'changes the question by attaching a file', js: true do
      within'.questions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      # save_and_open_page
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(user.last)
    visit questions_path
    click_on 'MyString'
    expect(page).to_not have_link 'Edit'
    # save_and_open_page
  end
end