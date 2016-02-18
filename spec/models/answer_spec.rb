require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  it { should belong_to(:question) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }
  it { should accept_nested_attributes_for :attachments }

  it "should validate uniqueness of body" do
    answer1 = Answer.create!(question: question, body: 'Answer', user: user)
    answer2 = Answer.new(question: question, body: 'Answer', user: user)
    expect(answer2).not_to be_valid
  end

  it_behaves_like "Model Votable" do
    subject { create(:answer) }
  end
end
