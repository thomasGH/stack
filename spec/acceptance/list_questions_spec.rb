require 'rails_helper'

feature 'List of questions', %q{
  In order to read content
  As any user
  I want to see list of questions
} do

  given!(:question) { create_list(:question, 3) }

  scenario 'User reads index page' do
    visit questions_path

    question.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end