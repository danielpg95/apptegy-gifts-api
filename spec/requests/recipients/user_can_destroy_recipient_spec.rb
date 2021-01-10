require 'rails_helper'

describe 'User can destroy recipient', type: :request do
  let!(:school) do
    create(:school)
  end

  context 'successfully' do
    let!(:recipient) do
      create(:recipient, school: school)
    end

    before do
      delete "/v1/recipient/#{school.id}", params: {id: recipient.id}
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

    context 'using wrong recipient id' do
      let!(:recipient) do
        create(:recipient, school: school)
      end

      before do
        delete "/v1/recipient/#{school.id}", params: {id: Faker::Alphanumeric.alphanumeric(number: 10)}
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The recipient does not exists"])
      end
    end

    context 'using disabled recipient id' do
      let!(:recipient) do
        create(:recipient, school: school, enabled: false)
      end

      before do
        delete "/v1/recipient/#{school.id}", params: {id: recipient.id}
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The recipient does not exists"])
      end
    end
  end
end