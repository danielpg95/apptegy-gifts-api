require 'rails_helper'

describe 'User can cancel order', type: :request do
  let!(:school) do
    create(:school)
  end

  let!(:first_recipient) do
    create(:recipient, school: school)
  end

  let!(:order) do
    order = create(:order, school: school)
    order.recipients << first_recipient
    order.gifts << Gift.find_by(gift_type: :hoodie)
    order
  end

  context 'successfully' do
    before do
      delete "/v1/order/#{school.id}", params: { order_id: order.id }
    end

    it 'returns a ok status' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'unsuccessfully' do
    context 'with shipped order' do
      before do
        order.update(status: :order_shipped)

        delete "/v1/order/#{school.id}", params: { order_id: order.id  }
      end

      it 'returns missing recipient ids validation' do
        expect(JSON.parse(response.body)['errors']['order_status']).to eq(
          ["Your order has already been shipped or is cancelled"]
        )
      end
    end

    context 'with incorrect school id' do
      before do
        delete "/v1/order/#{School.last.id + 1}",
          params: { order_id: order.id }
      end

      it 'returns missing school validation' do
        expect(JSON.parse(response.body)['errors']['school_id']).to eq(["The school does not exists"])
      end
    end

    context 'with incorrect order id' do
      before do
        delete "/v1/order/#{school.id}",
          params: { order_id: Faker::Alphanumeric.alphanumeric(number: 10) }
      end

      it 'returns missing order validation' do
        expect(JSON.parse(response.body)['errors']['order_id']).to eq(["The order does not exists"])
      end
    end
  end
end