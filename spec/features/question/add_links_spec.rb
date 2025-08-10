require 'rails_helper'

feature 'User can add links to question', %q{
  "In order to provide additional info to my question
  As an question's author
  I'd like to be able add links"
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_css("iframe[src*='#{gist_url}.pibb']")
  end

  scenario 'User adds new link to question when using cocoon' do
    sign_in(user)
    visit new_question_path

    click_on 'add link'
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[name]']", visible: true)
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[url]']", visible: true)
  end

  describe "Doesn't save question" do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario "with the missing URL" do
      fill_in 'Link name', with: 'My gist'
      click_on 'Ask'

      expect(page).to have_content "Links url can't be blank"
      expect(page).to have_content "Links url it is not valid URL"
    end

    scenario "with invalid url" do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'https://gist'
      click_on 'Ask'

      expect(page).to have_content "Links url it is not valid URL"
    end

    scenario "with the missing name" do
      fill_in 'Url', with: gist_url
      click_on 'Ask'

      expect(page).to have_content "Links name can't be blank"
    end
  end
end
