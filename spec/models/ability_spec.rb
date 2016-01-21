require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }

    it { should_not be_able_to :manage, Question }
    it { should_not be_able_to :manage, Answer } 
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question) }

    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :update, create(:answer, question: question, user: user) }

    it { should_not be_able_to :update, create(:question, user: other) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should be_able_to :destroy, create(:answer, question: question, user: user) }

    it { should_not be_able_to :destroy, create(:question, user: other) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }
  end
end