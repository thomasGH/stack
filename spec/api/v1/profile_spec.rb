require 'rails_helper'

RSpec.describe "Profiles API" do
  describe "GET /me" do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe "GET /index" do
    let!(:user_me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user_me.id) }

    it_behaves_like "API Authenticable" do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let!(:user_other) { create(:user) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns list of profiles' do
        expect(response.body).to have_json_size(1).at_path('profiles')
      end

      %w(id email created_at updated_at admin).each do |attr|
        it 'contains emails another users' do
          expect(response.body).to be_json_eql(user_other.send(attr).to_json).at_path("profiles/0/#{attr}")
        end
      end
    end
  end
end