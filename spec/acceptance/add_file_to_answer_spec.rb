require 'rails_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    login(user)
    visit question_path(question)
  end

  scenario 'User adds file when creates answer' do
    fill_in 'new_answer_body', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    visit question_path(question)

    expect(page).to have_link 'spec_helper.rb'
  end
end