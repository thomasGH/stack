require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to able to ask question
} do

  given!(:user) { create(:user) }

  scenario 'Authenticated user create question' do
    login(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text'
  end

  scenario 'Non-athenticated user tries to create question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end