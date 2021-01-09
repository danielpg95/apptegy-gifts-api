# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class CreateOrder
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:school_id])
    @recipients = @school.recipients.where(id: @params[:recipient_ids], enabled: true)
    @gifts = Gift.where(gift_type: @params[:gift_types])
  end

  def call
    order = Order.create(school_id: @school.id, status: :order_received)
    order.recipients << @recipients
    order.gifts << @gifts
    order
  end
end