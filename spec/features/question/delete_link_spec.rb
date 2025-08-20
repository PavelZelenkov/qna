require 'rails_helper'

feature 'The author can delete the link from his question.', %q{
  "As the author of the question, 
  I would like to be able to delete the link from my question."
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:link) { create(:link, linkable: question, name: "Link name", url: "https://gist.github.com") }

  scenario 'The author deletes the link from his question', js: true do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'

    click_on 'delete link'

    expect(page).to_not have_link 'Link name'
    # save_and_open_page
  end

  scenario "The author is trying to delete a link from someone else's question" do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'delete link'
    # save_and_open_page
  end
end