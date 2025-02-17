require 'rails_helper'

feature 'The user can view the list of questions', %q{
  "to find an answer to their question
  as an authorized user
  I would like to be able to view the entire list of questions"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }

  scenario 'Authenticated user views the list of questions' do
    sign_in(user)

    visit questions_path
    expect(page).to have_content 'MyString'
  end

  scenario 'Unauthenticated user views the list of questions' do
    visit questions_path
    expect(page).to have_content 'MyString'
  end
end
