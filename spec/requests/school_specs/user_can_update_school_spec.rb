require 'rails_helper'

describe 'User can update school', type: :request do
  let!(:name) do
    Faker::Name.name
  end

  let!(:address) do
    Faker::Address.full_address 
  end

  let!(:first_school) do
    create(:school)
  end

  let!(:second_school) do
    create(:school)
  end

  context 'successfully' do
    before do
      patch "/v1/schools/#{first_school.id}", params: { name: name, address: address }
    end
    
    it 'returns school name and address' do
      expect(JSON.parse(response.body)['data']["attributes"]['name']).to eq(name)
      expect(JSON.parse(response.body)['data']["attributes"]['address']).to eq(address)
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'missing school name' do
      before do
        patch "/v1/schools/#{first_school.id}", params: { address: address }
      end

      it 'returns missing name validation' do
        expect(JSON.parse(response.body)['errors']['name']).to eq(["can't be blank"])
      end
    end

    context 'missing school address' do
      before do
        patch "/v1/schools/#{first_school.id}", params: { name: name }
      end

      it 'returns missing address validation' do
        expect(JSON.parse(response.body)['errors']['address']).to eq(["can't be blank"])
      end
    end

    context 'using wrong school id' do
      before do
        patch "/v1/schools/#{School.last.id + 1}", params: { name: name, address: address }
      end

      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The school does not exists"])
      end
    end

    context 'using existing school name' do
      before do
        patch "/v1/schools/#{first_school.id}", params: { name: second_school.name, address: address }
      end

      it 'returns taken name validation' do
        expect(JSON.parse(response.body)['errors']['name']).to eq(["This name is already taken"])
      end
    end

    context 'using existing school address' do
      before do
        patch "/v1/schools/#{first_school.id}", params: { name: name, address: second_school.address }
      end

      it 'returns taken address validation' do
        expect(JSON.parse(response.body)['errors']['address']).to eq(["This address is already taken"])
      end
    end
  end
end