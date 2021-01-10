# Mock class for implementation of an email sending service
class SendOrderRecipientsEmails
  def initialize(params)
    @params = params
    @order = Order.find_by(id: @params[:order_id])
  end

  def call
    ShipmentMailer.order_shipped(@order.id).deliver
  end
end