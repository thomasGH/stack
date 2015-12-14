require 'rails_helper'

feature 'Signing in', %q{
  In order to bo able ask questions
  As an user
  I want to be able to sign in
} do
  scenario 'Existing user tries to sign in' do
    User.create(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'

#    save_and_open_page

    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_link 'Log out'
  end

  scenario 'Non-existing user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: 'wrong'

    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(page).to have_link 'Log out'
  end
end