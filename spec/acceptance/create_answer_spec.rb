require 'rails_helper'

feature 'Create answer', %q{
  In order to give the answer a question
  As an authenticated user
  I want to able to write question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    login(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'Test answer'
    click_on 'Create'

    within '.answers' do
      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'Non-athenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Your answer'
  end
end