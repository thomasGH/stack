require 'rails_helper'

feature 'Create answer', %q{
  In order to give the answer a question
  As an authenticated user
  I want to able to write question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer' do
    login(user)

    visit question_path(question)

    click_on 'To answer'
    fill_in 'Body', with: 'Test answer'

    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'Test answer'
  end

  scenario 'Non-athenticated user tries to create answer' do
    visit question_path(question)

    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end