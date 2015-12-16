require 'rails_helper'

feature 'List of questions', %q{
  In order to read content
  As any user
  I want to show list of questions
} do

  given!(:question) { create_list(:question, 3) }

  scenario 'User reads index page' do
    visit questions_path
    expect(page).to have_content 'My question 1'
    expect(page).to have_content 'My question 2'
    expect(page).to have_content 'My question 3'
    expect(current_path).to eq questions_path
  end
end