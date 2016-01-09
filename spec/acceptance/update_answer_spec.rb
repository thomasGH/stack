require 'rails_helper'

feature 'Updating the answer', %q{
  In order to the answer can be edit
  As an authenticated user
  I want to edit answer
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author can edit answer', js: true do
    login(user)
    visit question_path(question)
    click_on 'Edit answer'
    fill_in 'new_answer_body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'text text'
  end

  scenario "Non-author can't edit answer" do
    login(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end