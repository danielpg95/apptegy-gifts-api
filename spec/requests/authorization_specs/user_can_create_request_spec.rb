require 'rails_helper'

describe 'User can create request', type: :request do
  let!(:auth_token) do
    AuthenticateUser.new({username: 'apptegy', password: 'apptegy'}).call
  end

  let!(:school) do
    create(:school)
  end

  let!(:recipient) do
    create(:recipient, school: school)
  end

  context 'successfully with valid token' do
    before do
      # Credentials for the single user that was included in the seed
      get "/v1/recipient/#{school.id}", headers: {authorization: auth_token}
    end

    it 'returns recipient list' do
      expect(JSON.parse(response.body)['data']).not_to be nil
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully with invalid token' do
    context 'using invalid credentials' do
      before do
        get "/v1/recipient/#{school.id}", headers: {authorization: Faker::Alphanumeric.alphanumeric(number: 10)}
      end
  
      it 'unauthorized error message validation' do
        expect(JSON.parse(response.body)['token']).to eq('The authorization token provided is invalid')
      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end