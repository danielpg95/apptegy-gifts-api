require 'rails_helper'

describe 'User can view orders', type: :request do
  let!(:auth_token) do
    AuthenticateUser.new({username: 'apptegy', password: 'apptegy'}).call
  end

  let!(:school) do
    create(:school)
  end

  let!(:recipient) do
    create(:recipient, school: school)
  end

  let!(:order) do
    order = create(:order, school: school)
    order.recipients << recipient
    order.gifts << Gift.find_by(gift_type: :hoodie)
    order
  end

  context 'successfully' do
    before do
      get "/v1/order/#{school.id}", headers: {authorization: auth_token}
    end

    it 'returns a list of school orders' do
      first_object_json_attributes = JSON.parse(response.body)['data'][0]['attributes']
      expect(JSON.parse(response.body)['data'][0]['id']).to eq(order.id.to_s)
      expect(first_object_json_attributes['status']).to eq(order.status)
      expect(first_object_json_attributes['recipients']).to eq(
        [{ "first-name"=> recipient.first_name,
           "last-name"=> recipient.last_name,
           "address"=> recipient.address }]
      )
      expect(first_object_json_attributes['gifts']).to eq(
        [{ "gift-type"=> order.gifts.first.gift_type }]
      )
      expect(first_object_json_attributes['school']).to eq(
        { "name"=> school.name }
      )
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'using wrong school id' do
      before do
        get "/v1/order/#{School.last.id + 1}", headers: {authorization: auth_token}
      end
  
      it 'returns not found validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end
  end
end