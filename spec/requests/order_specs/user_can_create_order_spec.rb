require 'rails_helper'

describe 'User can create order', type: :request do
  let!(:auth_token) do
    AuthenticateUser.new({username: 'apptegy', password: 'apptegy'}).call
  end

  let!(:school) do
    create(:school)
  end

  let!(:first_recipient) do
    create(:recipient, school: school)
  end

  let!(:second_recipient) do
    create(:recipient, school: school)
  end

  context 'successfully' do
    before do
      post "/v1/order/#{school.id}",
        params: { recipient_ids: [first_recipient.id, second_recipient.id], gift_types: [:mug, :t_shirt] },
        headers: {authorization: auth_token}
    end
    
    it 'returns order' do
      json_attributes = JSON.parse(response.body)['data']["attributes"]
      expect(json_attributes['status']).to eq(Order.last.status)
      expect(json_attributes['recipients'][0]).to eq(
        { 'first-name' => first_recipient.first_name,
          'last-name' => first_recipient.last_name,
          'address' => first_recipient.address }
      )
      expect(json_attributes['gifts'][0]).to eq(
        { 'gift-type' => 'mug'}
      )
      expect(json_attributes['school']['name']).to eq(school.name)
    end

    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end

  context 'unsuccessfully' do
    context 'with incorrect school id' do
      before do
        post "/v1/order/#{School.last.id + 1}",
          params: { recipient_ids: [first_recipient.id, second_recipient.id], gift_types: [:mug, :t_shirt] },
          headers: {authorization: auth_token}
      end

      it 'returns missing school validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end

    context 'missing recipient ids' do
      before do
        post "/v1/order/#{school.id}",
          params: { gift_types: [:mug, :t_shirt] },
          headers: {authorization: auth_token}
      end

      it 'returns missing recipient ids validation' do
        expect(JSON.parse(response.body)['errors']['recipient_ids']).to eq(["Missing recipient or wrong id given"])
      end
    end

    context 'with disabled recipient id' do
      before do
        second_recipient.update(enabled: false)

        post "/v1/order/#{school.id}",
          params: { recipient_ids: [first_recipient.id, second_recipient.id], gift_types: [:mug, :t_shirt] },
          headers: {authorization: auth_token}
      end

      it 'returns missing recipient ids validation' do
        expect(JSON.parse(response.body)['errors']['recipient_ids']).to eq(["Missing recipient or wrong id given"])
      end
    end

    context 'missing gift types' do
      before do
        post "/v1/order/#{school.id}",
          params: { recipient_ids: [first_recipient.id, second_recipient.id] },
          headers: {authorization: auth_token}
      end

      it 'returns missing gifts invalid type validation' do
        expect(JSON.parse(response.body)['errors']['gift_types']).to eq(["Gift types are not valid"])
      end
    end

    context 'wrong gift types' do
      before do
        post "/v1/order/#{school.id}",
          params: { recipient_ids: [first_recipient.id, second_recipient.id], gift_type: [:jacket] },
          headers: {authorization: auth_token}
      end

      it 'returns missing gifts invalid type validation' do
        expect(JSON.parse(response.body)['errors']['gift_types']).to eq(["Gift types are not valid"])
      end
    end
  end

  context 'exceeding recipients limit' do
    before do
      (1...25).each do |_index|
        create(:recipient, school: school)
      end
      post "/v1/order/#{school.id}",
        params: { recipient_ids: school.recipients.ids, gift_types: [:mug, :t_shirt, :hoodie, :sticker] },
        headers: {authorization: auth_token}
    end

    it 'returns order limit exceeded validation' do
      expect(JSON.parse(response.body)['errors']['recipients_limit_exceeded']).to eq(
        ["The order can not be created because it exceeds the recipients limit per order"]
      )
    end
  end

  context 'exceeding order limit' do
    before do
      (1...20).each do |_index|
        create(:recipient, school: school)
      end
      post "/v1/order/#{school.id}",
        params: { recipient_ids: school.recipients.ids, gift_types: [:mug, :t_shirt, :hoodie, :sticker] },
        headers: {authorization: auth_token}
    end

    it 'returns order limit exceeded validation' do
      expect(JSON.parse(response.body)['errors']['order_limit_exceeded']).to eq(
        ["The order can not be created because it exceeds the sent limit per day"]
      )
    end
  end
end