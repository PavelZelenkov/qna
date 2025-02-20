require 'rails_helper'

feature 'The author can delete his question.', %q{
  "As the author of the question, 
  I would like to be able to delete my question"
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }

  scenario 'The author deletes his question' do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'
    click_on 'delete question'

    expect(page).to have_content 'Your question has been successfully deleted'
  end

  scenario "The author is trying to delete someone else's question" do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'delete question'
  end
end
