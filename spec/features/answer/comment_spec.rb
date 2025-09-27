require 'rails_helper'

feature 'The user can leave comments', %q{
  "As an authorized user,
I would like to leave comments.."
} do

  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }

  scenario 'An authenticated user leaves a comment on the answer' do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    within '.answers' do
      fill_in 'your comment', with: 'text body comment'
      click_on 'Send'
    end
    expect(page).to have_content 'text body comment'
  end

  scenario 'An unauthenticated user is attempting to leave a comment on a answer' do
    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'your comment'
  end
end
