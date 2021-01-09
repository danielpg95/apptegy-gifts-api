require 'rails_helper'

describe 'User can update recipient', type: :request do
  let!(:school) do
    create(:school)
  end

  let!(:recipient) do
    create(:recipient, school: school)
  end
  
  let!(:first_name) do
    Faker::Name.name
  end

  let!(:last_name) do
    Faker::Name.name
  end

  let!(:address) do
    Faker::Address.full_address 
  end

  context 'successfully' do
    before do
      patch "/v1/recipient/#{school.id}",
        params: { id: recipient.id, first_name: first_name, last_name: last_name, address: address }
    end
    
    it 'returns recipient and the school it belongs' do
      json_attributes = JSON.parse(response.body)['data']["attributes"]
      expect(JSON.parse(response.body)['data']['id']).to eq(recipient.id.to_s)
      expect(json_attributes['first-name']).to eq(first_name)
      expect(json_attributes['last-name']).to eq(last_name)
      expect(json_attributes['address']).to eq(address)
      expect(json_attributes['school']['name']).to eq(school.name)
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'with incorrect school id' do
      before do
        patch "/v1/recipient/#{Faker::Alphanumeric.alphanumeric(number: 10)}",
          params: { id: recipient.id, first_name: first_name, last_name: last_name, address: address }
      end

      it 'returns missing school validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end

    context 'with incorrect recipient id' do
      before do
        patch "/v1/recipient/#{school.id}", params: { id: Faker::Alphanumeric.alphanumeric(number: 10) ,
                                                      first_name: first_name,
                                                      last_name: last_name,
                                                      address: address }
      end

      it 'returns missing recipient validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The recipient does not exists"])
      end
    end

    context 'with disabled recipient' do
      before do
        recipient.update(enabled: false)
        patch "/v1/recipient/#{school.id}", params: { id: recipient.id,
                                                      first_name: first_name,
                                                      last_name: last_name,
                                                      address: address }
      end

      it 'returns missing recipient validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The recipient does not exists"])
      end
    end

    context 'missing recipient first name' do
      before do
        patch "/v1/recipient/#{school.id}", params: { id: recipient.id, last_name: last_name, address: address }
      end

      it 'returns missing first name validation' do
        expect(JSON.parse(response.body)['errors']['first_name']).to eq(["can't be blank"])
      end
    end

    context 'missing recipient last name' do
      before do
        patch "/v1/recipient/#{school.id}", params: { id: recipient.id, first_name: first_name, address: address }
      end

      it 'returns missing last name validation' do
        expect(JSON.parse(response.body)['errors']['last_name']).to eq(["can't be blank"])
      end
    end

    context 'missing recipient address' do
      before do
        patch "/v1/recipient/#{school.id}", params: { id: recipient.id, first_name: first_name, last_name: last_name }
      end

      it 'returns missing address validation' do
        expect(JSON.parse(response.body)['errors']['address']).to eq(["can't be blank"])
      end
    end
  end
end