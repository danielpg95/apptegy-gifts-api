# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class UpdateOrder
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:school_id])
    @recipients = @school.recipients.where(id: @params[:recipient_ids], enabled: true)
    @gifts = Gift.where(gift_type: @params[:gift_types])
    @order = @school.orders.find_by(id: @params[:order_id])
  end

  def call
    # To make it faster, all relationships are re-created, even though is not efficient in bigger scenarios
    update_order_relationships
    @order
  end

  def update_order_relationships
    update_order_recipients
    update_order_gifts
  end

  def update_order_recipients
    @order.recipient_orders.destroy_all
    @order.recipients << @recipients
  end

  def update_order_gifts
    @order.order_gifts.destroy_all
    @order.gifts << @gifts
  end
end