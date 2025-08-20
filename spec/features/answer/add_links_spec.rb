require 'rails_helper'

feature 'User can add links to answer', %q{
  "In order to provide additional info to my answer
  As an answer's author
  I'd like to be able add links"
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author_id: user.id) }
  given(:gist_url) { 'https://gist.github.com/PavelZelenkov/0f47e461a01fb077db0824e2f2429a97' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit questions_path
    click_on 'MyString'

    fill_in 'Body', with: 'My answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_css("iframe[src*='#{gist_url}.pibb']")
    end
  end

  scenario 'User adds new link to answer when using cocoon', js: true do
    sign_in(user)
    visit questions_path
    click_on 'MyString'

    click_on 'add link'
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[name]']", visible: true)
    expect(page).to have_selector("input[name*='[links_attributes]'][name*='[url]']", visible: true)
  end

  describe "Doesn't save answer" do
    background do
      sign_in(user)
      visit questions_path
      click_on 'MyString'
    end
    
    scenario "with the missing URL" do
      fill_in 'Link name', with: 'My gist'
      click_on 'Answer'

      expect(page).to have_content "Links url can't be blank"
      expect(page).to have_content "Links url it is not valid URL"
    end

    scenario "with invalid url" do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: 'https://gist'
      click_on 'Answer'

      expect(page).to have_content "Links url it is not valid URL"
    end

    scenario "with the missing name" do
      fill_in 'Url', with: gist_url
      click_on 'Answer'

      expect(page).to have_content "Links name can't be blank"
    end
  end
end
