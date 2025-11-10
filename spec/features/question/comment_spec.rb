require 'rails_helper'

feature 'The user can leave comments', %q{
  "As an authorized user,
I would like to leave comments.."
} do

  given(:user) { create_list(:user, 2) }
  given!(:question) { create(:question, author_id: user.first.id) }

  scenario 'An authenticated user leaves a comment on the question' do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    fill_in 'your comment', with: 'text body comment'
    click_on 'Send'

    expect(page).to have_content 'text body comment'
  end

  scenario "An authenticated user leaves a comment on someone else's question" do
    sign_in(user.first)

    visit questions_path
    click_on 'MyString'

    fill_in 'your comment', with: 'text body comment'
    click_on 'Send'

    expect(page).to have_content 'text body comment'
  end

  scenario 'An authorized user is attempting to post an empty comment' do
    sign_in(user.last)

    visit questions_path
    click_on 'MyString'

    click_on 'Send'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'An unauthenticated user is attempting to leave a comment on a question' do
    visit questions_path
    click_on 'MyString'

    expect(page).to_not have_content 'your comment'
  end

  context "multiple sessions", js: true do
    scenario "a comment to a question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user.last)

        visit questions_path
        click_on 'MyString'

        fill_in 'your comment', with: 'text body comment'
        click_on 'Send'

        expect(page).to have_content 'text body comment'
      end

      Capybara.using_session('guest') do
        visit questions_path
        click_on 'MyString'
        expect(page).to have_content 'text body comment'
      end
    end
  end
end
