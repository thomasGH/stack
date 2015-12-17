require 'rails_helper'

feature 'Show qestion and answers', %q{
  In order to see question with answers
  As any user
  I want to see question page
} do

  given!(:answer) { create(:answer) }
  
  scenario 'User reads page of the question' do
    visit question_path(answer.question)

    expect(page).to have_content 'My question'
    expect(page).to have_content "Question's Body"
    expect(page).to have_content "Answer body"
  end
end