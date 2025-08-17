require 'rails_helper'

feature 'The user can view the list of award', %q{
  "as an authorized user
  I would like to be able to view the full list of my awards"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, author_id: user.id) }

  before do
    award = Award.new(name: 'NameAward', question: question)
    award.image.attach(
      io: File.open(Rails.root.join('spec/fixtures/files/award1.jpg')),
      filename: "award1.jpg"
    )
    award.save!
  end

  scenario 'The user sees his awards' do
    sign_in(user)

    visit questions_path
    click_on 'MyString'

    click_on 'choose the best answer'

    visit user_awards_path(user)

    expect(page).to have_content 'NameAward'
    expect(page).to have_css("img[src*='award1.jpg']")
    # save_and_open_page
  end

  scenario 'The user has no awards' do
    sign_in(user)

    visit questions_path
    click_on 'Awards'

    expect(page).to have_content 'You have no awards'
  end

  scenario 'Unauthorized user does not see rewards' do
    visit questions_path
    expect(page).to_not have_content 'Awards'
  end
end