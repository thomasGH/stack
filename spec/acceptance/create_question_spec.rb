require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to able to ask question
} do
  given!(:user) { create(:user) }

  scenario 'Authenticated user create question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit question_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text'
    click_on 'Create'
end