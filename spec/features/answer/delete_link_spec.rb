require 'rails_helper'

feature 'The author of the answer can remove the link from his answer.', %q{
  "As the author of the answer, 
  I would like to be able to delete the link from my answer."
} do

  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }
  given!(:link) { create(:link, linkable: answer, name: "Link name", url: "https://gist.github.com") }

  scenario 'The author of the answer removes the link from his answer', js: true do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'
    
    click_on 'delete link'

    expect(page).to_not have_link 'Link name'
    # save_and_open_page
  end

  scenario "The author is trying to delete a link from someone else's answer" do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'delete link'
  end
end