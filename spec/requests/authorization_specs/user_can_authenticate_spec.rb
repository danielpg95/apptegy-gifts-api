require 'rails_helper'

describe 'User can authenticate', type: :request do
  let!(:school) do
    create(:school)
  end

  let!(:recipient) do
    create(:recipient, school: school)
  end

  context 'successfully' do
    before do
      # Credentials for the single user that was included in the seed
      post "/v1/authenticate/", params: {username: 'apptegy', password: 'apptegy'}
    end

    it 'returns an authorization token' do
      expect(JSON.parse(response.body)['auth_token']).not_to be nil
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'using invalid credentials' do
      before do
        post "/v1/authenticate/", params: {username: Faker::Name.name, password: Faker::Name.name }
      end
  
      it 'returns user authentication validation error message' do
        expect(JSON.parse(response.body)['errors']['user_authentication']).to eq("Username or password is incorrect")
      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end