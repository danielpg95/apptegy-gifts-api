require 'rails_helper'

describe 'User can destroy school', type: :request do
  let!(:auth_token) do
    AuthenticateUser.new({username: 'apptegy', password: 'apptegy'}).call
  end

  let!(:school) do
    create(:school)
  end

  context 'successfully' do
    before do
      delete "/v1/schools/#{school.id}", headers: {authorization: auth_token}
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'using wrong school id' do
      before do
        delete "/v1/schools/#{School.last.id + 1}", headers: {authorization: auth_token}
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The school does not exists"])
      end
    end
  end
end