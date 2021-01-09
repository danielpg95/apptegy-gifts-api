require 'rails_helper'

describe 'User can destroy school', type: :request do
  let!(:school) do
    create(:school)
  end

  context 'successfully' do
    before do
      delete "/v1/schools/#{school.id}"
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'using wrong school id' do
      before do
        delete "/v1/schools/#{Faker::Number.number(digits: 2)}"
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['id']).to eq(["The school does not exists"])
      end
    end
  end
end