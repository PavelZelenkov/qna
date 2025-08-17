require 'rails_helper'

feature 'User can add a reward for the best answer', %q{
  "As the author of the question,
  I would like to be able to add a bounty for the best answer when creating a question"
} do

  given(:user) { create(:user) }
  given(:image) { Rails.root.join('spec/fixtures/files/award1.jpg') }

  describe "Saves the question" do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'The user adds a reward for the best answer when asking a question' do
      fill_in 'Name of the award', with: 'Test award'
      attach_file 'Picture of the award', image

      click_on 'Ask'
      
      expect(page).to have_content 'Test award'
      expect(page).to have_css("img[src*='award1.jpg']")
    end

    scenario 'The user asks a question without a reward' do
      click_on 'Ask'

      expect(page).to have_content "No reward for this question"
    end
  end

  describe "Doesn't save question" do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'award name missing' do
      attach_file 'Picture of the award', image
      click_on 'Ask'

      expect(page).to have_content "Award name can't be blank"
    end

    scenario 'no award picture' do
      fill_in 'Name of the award', with: 'Test award'
      click_on 'Ask'

      expect(page).to have_content "Award image can't be blank"
    end
    # save_and_open_page
  end
end