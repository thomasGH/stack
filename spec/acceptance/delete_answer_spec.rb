require 'rails_helper'

feature 'Deleting the answer', %q{
  In order to the answer can be delete
  As an authenticated user
  I want to delete answer
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:question_with_answers, 1, question: question, user: user) }

  scenario 'Author can delete answer', js: true do
    login(user)
    visit question_path(question)
    click_on 'Delete answer'
    page.driver.browser.switch_to.alert.accept

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content answers.first.body
  end

  scenario "Non-author can't delete answer" do
    login(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario "Unauthenticated user can't delete answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end