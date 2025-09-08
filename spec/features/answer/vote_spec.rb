require 'rails_helper'

feature 'The user can vote for the answer', %q{
  "As an authorized user, 
  I would like to vote for the answer I like."
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user.last)

      visit questions_path
      click_on 'MyString'
    end

    scenario "likes someone else's answer" do
      within "#answer-#{answer.id}" do
        click_on 'Like'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '1')
      end
    end

    scenario "Dislikes someone else's answer" do
      within "#answer-#{answer.id}" do
        click_on 'Dislike'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '-1')
      end
    end

    scenario "likes someone else's answer again" do
      within "#answer-#{answer.id}" do
        click_on 'Like'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '1')
        click_on 'Like'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '0')
      end
    end

    scenario "Disikes someone else's answer again" do
      within "#answer-#{answer.id}" do
        click_on 'Dislike'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '-1')
        click_on 'Dislike'
        expect(page).to have_selector("#rating_answer_#{answer.id}", text: '0')
      end
    end
  end

  scenario "An authenticated user votes for their answer" do
    sign_in(user.first)
    visit questions_path
    click_on 'MyString'

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end
  end

  scenario "An unauthenticated user votes for their answer" do
    visit questions_path
    click_on 'MyString'

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
    end
  end
end
