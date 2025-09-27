require 'rails_helper'

feature 'User can edit his answer', %q{
  "In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer"
} do

  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }
  given!(:link) { create(:link, linkable: answer, name: "Link name", url: "https://gist.github.com") }

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
        expect(page).to have_no_selector("#answer_body", visible: :visible)
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

    scenario 'edits his answer to add the file', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      # save_and_open_page
    end

    scenario 'edits his answer to add the link', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit'

      within '.answers' do
        click_on 'add link'
        within all('.nested-fields').last do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97'
        end
        click_on 'Save'
      end
      expect(page).to have_link('My gist', href: 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97')
      # save_and_open_page
    end

    scenario 'edits his answer to edit the link', js: true do
      sign_in(user.first)
      visit questions_path
      click_on 'MyString'
      click_on 'Edit'

      within '.answers' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97'
        click_on 'Save'
      end
      expect(page).to have_link('My gist', href: 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97')
      # save_and_open_page
    end
  end
end
