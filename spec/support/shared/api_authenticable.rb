shared_examples_for "API Authenticable" do
  context "unauthorized" do
    it 'returns 401 status if request has not access token' do
      do_request(method, api_path)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_request(method, api_path, access_token: '1234')
      expect(response.status).to eq 401
    end
  end

  context "authorized" do
    it 'returns 200 status if access token is valid' do
      do_request(method, api_path, access_token: access_token.token)
      expect(response).to be_success
    end
  end
end