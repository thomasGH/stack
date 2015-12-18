require 'rails_helper'

feature 'Show qestion and answers', %q{
  In order to see question with answers
  As any user
  I want to see question page
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:question_with_answers, 3, question: question) }
  
  scenario 'User reads page of the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end