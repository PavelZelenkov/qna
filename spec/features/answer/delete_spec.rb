require 'rails_helper'

feature 'The author can delete his answer.', %q{
  "As the author of the answer
  I would like to be able to delete my answer to the question"
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.first.id) }

  scenario 'The author deletes his answer to the question' do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'
    click_on 'Delete'
    expect(page).to have_content 'Your answer has been successfully deleted'
  end

  scenario "The author is trying to delete someone else's answer to the question" do
    sign_in(user.last)
    visit questions_path
    click_on 'MyString'
    
    expect(page).to_not have_content 'Delete'
  end
end
