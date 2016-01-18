require 'rails_helper'

RSpec.describe User do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#author_of?' do
    let!(:user) { create(:user) }
    
    it 'return true if user is author of object' do
      object = create(:question, user: user)
      # expect(user.author_of?(object)).to be_truthy
      expect(user).to be_author_of(object)
    end

    it 'return false if user is not author of object' do
      object = create(:question)
      expect(user).to_not be_author_of(object)
    end
  end

  describe '.find_for_oauth' do
    context 'user already has authorization' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '12345678') }

      it 'returns the user' do
        user.authorizations.create(provider: 'provider', uid: '12345678')
        expect(User.find_for_oauth()).to eq user
      end
    end

    context 'user email already exists' do
      let!(:user) { create(:user) }
      let(:auth) { OmniAuth::AuthHash.new(provider: 'provider', uid: '12345678', info: { email: user.email }) }

      it 'does not create new user' do
        expect { User.find_for_oauth(auth) }.to_not change(User, :count)
      end

      it 'create authorizations for user' do
        expect { User.find_for_oauth(auth) }.to change(user.authorization)
      end

      it 'returns user' do
        expect()
      end
    end

    context 'user email does not exist' do
    end
  end
end
