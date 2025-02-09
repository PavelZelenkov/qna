require 'rails_helper'

feature 'The user can view a list of answers to the question', %q{
  "As an authenticated user
  I would like to be able to see all answers to a question"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question_id: question.id)}

  scenario 'An authenticated user views the question and answers to the question' do
    sign_in(user)

    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyStringAnswer'
  end

  scenario 'An unauthorized user is viewing a question and the list of answers to the question' do
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content 'MyStringAnswer'
  end
end