require 'rails_helper'

describe 'User can view recipients', type: :request do
  let!(:school) do
    create(:school)
  end

  let!(:recipient) do
    create(:recipient, school: school)
  end

  context 'successfully' do
    before do
      get "/v1/recipient/#{school.id}"
    end

    it 'returns a list of school recipients' do
      first_object_json_attributes = JSON.parse(response.body)['data'][0]['attributes']
      expect(JSON.parse(response.body)['data'][0]['id']).to eq(recipient.id.to_s)
      expect(first_object_json_attributes['first-name']).to eq(recipient.first_name)
      expect(first_object_json_attributes['last-name']).to eq(recipient.last_name)
      expect(first_object_json_attributes['address']).to eq(recipient.address)
      expect(first_object_json_attributes['school']['name']).to eq(school.name)
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'using wrong school id' do
      before do
        delete "/v1/recipient/#{School.last.id + 1}"
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end
  end
end