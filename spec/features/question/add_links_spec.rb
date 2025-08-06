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
  end

  scenario 'User adds new link to question when using cocoon', js: true do
    sign_in(user)
    visit new_question_path

    click_on 'add link'
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[name]']", visible: true)
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[url]']", visible: true)
    # save_and_open_page
  end
end
