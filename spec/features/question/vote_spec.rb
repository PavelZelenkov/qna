require 'rails_helper'

feature 'The user can vote for the question', %q{
  "As an authorized user, 
  I would like to vote for the question I like."
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user.last)

      visit questions_path
      click_on 'MyString'
    end

    scenario "likes someone else's question" do
      click_on 'Like'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '1')
    end

    scenario "Dislikes someone else's question" do
      click_on 'Dislike'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '-1')
    end

    scenario "likes someone else's question again" do
      click_on 'Like'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '1')
      click_on 'Like'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '0')
    end

    scenario "Disikes someone else's question again" do
      click_on 'Dislike'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '-1')
      click_on 'Dislike'
      expect(page).to have_selector("#rating_question_#{question.id}", text: '0')
    end
  end

  scenario "An authenticated user votes for their question", js: true do
    sign_in(user.first)
    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end

  scenario "An unauthenticated user votes for their question" do
    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_link 'Like'
    expect(page).to_not have_link 'Dislike'
  end
end
