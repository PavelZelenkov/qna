require 'rails_helper'

feature 'The author can delete the file from his question.', %q{
  "As the author of the question, 
  I would like to be able to delete the file from my question."
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }

  before do
    question.files.attach(
      io: File.open(Rails.root.join("spec/rails_helper.rb")),
      filename: "rails_helper.rb"
    )
  end

  scenario 'The author deletes the file from his question', js: true do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'

    click_on 'delete file'

    expect(page).to_not have_link 'rails_helper.rb'
    # save_and_open_page
  end

  scenario "The author is trying to delete a file from someone else's question" do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'delete file'
    # save_and_open_page
  end

end
