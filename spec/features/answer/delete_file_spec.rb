require 'rails_helper'

feature 'The author of the answer can remove the file from his answer.', %q{
  "As the author of the answer, 
  I would like to be able to delete the file from my answer."
} do

  given!(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }
  given!(:answer) { create(:answer, author_id: user.first.id, question_id: question.id) }

  before do
    answer.files.attach(
      io: File.open(Rails.root.join("spec/rails_helper.rb")),
      filename: "rails_helper.rb"
    )
  end

  scenario 'The author of the answer removes the file from his answer', js: true do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'
    
    click_on 'delete file'

    expect(page).to_not have_link 'rails_helper.rb'
    # save_and_open_page
  end

  scenario "The author is trying to delete a file from someone else's answer" do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'delete file'
  end
end