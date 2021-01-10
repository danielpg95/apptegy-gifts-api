require 'rails_helper'

describe 'User can ship order', type: :request do
  let!(:school) do
    create(:school)
  end

  let!(:first_recipient) do
    create(:recipient, school: school)
  end

  let!(:second_recipient) do
    create(:recipient, school: school)
  end

  let!(:order) do
    order = create(:order, school: school)
    order.recipients << [first_recipient, second_recipient]
    order.gifts << Gift.where(gift_type: %i[mug t_shirt hoodie sticker])
    order
  end

  context 'successfully' do
    before do
      post "/v1/ship_order/#{school.id}", params: { order_id: order.id, send_emails: true }
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

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'with shipped order' do
      before do
        order.update(status: :order_shipped)

        post "/v1/ship_order/#{school.id}", params: { order_id: order.id }
      end

      it 'returns order status validation' do
        expect(JSON.parse(response.body)['errors']['order_status']).to eq(
          ["Your order has already been shipped or is cancelled"]
        )
      end
    end

    context 'with incorrect school id' do
      before do
        post "/v1/ship_order/#{School.last.id + 1}", params: { order_id: order.id }
      end

      it 'returns missing school validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end

    context 'with incorrect order id' do
      before do
        post "/v1/ship_order/#{school.id}", params: { order_id: Faker::Alphanumeric.alphanumeric(number: 10)}
      end

      it 'returns missing order validation' do
        expect(JSON.parse(response.body)['errors']['order_id']).to eq(["The order does not exists"])
      end
    end

    context 'exceeding shipping limit' do
      before do
        (1...14).each do |_index|
          order = create(:order, school: school, shipped_at: Time.now, status: :order_shipped)
          order.recipients << [first_recipient, second_recipient]
          order.gifts << Gift.where(gift_type: %i[mug t_shirt hoodie sticker])
          order
        end
        post "/v1/ship_order/#{school.id}", params: { order_id: order.id }
      end

      it 'returns order limit exceeded validation' do
        expect(JSON.parse(response.body)['errors']['shipment_limit_exceeds']).to eq(
          ["The order can not be shipped because the school reached or will reach the quota for today"]
        )
      end
    end
  end
end