# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class CancelOrder
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:school_id])
    @order = @school.orders.find_by(id: @params[:order_id])
  end

  def call
    @order.update(status: :order_cancelled)
  end
end