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
  # it { should validate_uniqueness_of (:body) }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like "Votable" do
    subject { create(:answer) }
  end

  # describe 'sends notifications to' do
  #   let(:users) { create_list(:user, 3) }
  #   let(:question) { create(:question) }
  #   let(:answer) { create(:answer) }

  #   it 'suscribers' do 
  #     users.each do |user|
  #       expect(NotificationMailer).to receive(:answer_notification).with(user, question, answer).and_call_original
  #       NotificationMailer.deliver_now
  #     end
  #   end

  #   it 'owner of question' do
  #     expect(NotificationMailer).to receive(:answer_notification).with(question.user, question, answer).and_call_original
  #     ActionMailer::Base.perform_now
  #     NotificationMailer.deliver_now
  #   end
  # end
end
