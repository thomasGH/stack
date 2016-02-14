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
end
