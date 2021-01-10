# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class ShipOrder
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:school_id])
    @order = @school.orders.find_by(id: @params[:order_id])
  end

  def call
    @order.update(status: :order_processing)
    ShipmentMailer.order_shipped(@order.id).deliver if @params[:send_emails]
    @order.update(status: :order_shipped, shipped_at: Time.now)
    @order.reload
  end
end