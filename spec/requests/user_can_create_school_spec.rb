require 'rails_helper'

describe 'User can create school', type: :request do
  let!(:name) do
    Faker::Name.name
  end

  let!(:address) do
    Faker::Address.full_address 
  end

  context 'successfully' do
    before do
      post '/v1/schools', params: { name: name, address: address }
    end
    
    it 'returns school name and address' do
      expect(JSON.parse(response.body)['data']["attributes"]['name']).to eq(name)
      expect(JSON.parse(response.body)['data']["attributes"]['address']).to eq(address)
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end

  context 'unsuccessfully' do
    context 'missing school name' do
      before do
        post '/v1/schools', params: { address: address }
      end

      it 'returns missing name validation' do
        expect(JSON.parse(response.body)['errors']['name']).to eq(["can't be blank"])
      end
    end

    context 'using existing school name' do
      let!(:school) do
        create(:school)
      end

      before do
        post '/v1/schools', params: { name: school.name, address: address }
      end

      it 'returns taken name validation' do
        expect(JSON.parse(response.body)['errors']['name']).to eq(["This name is already taken"])
      end
    end

    context 'missing school address' do
      before do
        post '/v1/schools', params: { name: name }
      end

      it 'returns missing name validation' do
        expect(JSON.parse(response.body)['errors']['address']).to eq(["can't be blank"])
      end
    end

    context 'using existing school address' do
      let!(:school) do
        create(:school)
      end

      before do
        post '/v1/schools', params: { name: name, address: school.address }
      end

      it 'returns taken address validation' do
        expect(JSON.parse(response.body)['errors']['address']).to eq(["This address is already taken"])
      end
    end
  end
end