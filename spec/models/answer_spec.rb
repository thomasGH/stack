require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to :user }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }

  it { should validate_uniqueness_of (:body) }

end
