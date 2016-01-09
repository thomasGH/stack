require 'rails_helper'

feature 'Updating the question', %q{
  In order to the qustion can be edit
  As an authenticated user
  I want to edit question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author can edit question', js: true do
    login(user)
    visit question_path(question)
    click_on 'Edit question'
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'text text'
    click_on 'Update'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario "Non-author can't edit question" do
    login(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Unauthenticated user can't edit question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end