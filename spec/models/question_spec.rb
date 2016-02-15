require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:best_answer).class_name("Answer") }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:subscribers_questions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscribers_questions).source(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }

  it { should validate_uniqueness_of (:title) }
  it { should validate_length_of(:title).is_at_most(200) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "Model Votable" do
    subject { create(:question) }
  end

  describe '#make_best' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'set best answer_id to question' do
      question.make_best(answer)
      expect(question.best_answer).to eq answer
    end
  end
end
