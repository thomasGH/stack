require 'rails_helper'

feature 'Deleting the question', %q{
  In order to the qustion can be delete
  As an authenticated user
  I want to delete question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Author can delete question' do
    login(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario "Non-author can't delete question" do
    login(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario "Unauthenticated user can't delete question" do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end