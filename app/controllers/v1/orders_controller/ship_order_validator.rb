module V1
  class OrdersController
    # ShipOrder controller action validator
    class ShipOrderValidator < BaseValidator
      attr_accessor :school_id, :order_id, :send_emails

      before_validation :find_school, :find_order

      validates :school_id, :order_id, presence: true
      validates :send_emails, inclusion: { in: [true, false] }, if: :send_emails
      validate :school_exists, :order_exists, :valid_order_status, :shipment_available?

      private

      def find_school
        @school = School.find_by(id: school_id)
      end

      def find_order
        return unless @school

        @order = @school.orders.find_by(id: order_id)
      end

      def school_exists
        errors.add(:school_id, t('order.attributes.school_id.not_found')) unless @school
      end

      def order_exists
        errors.add(:order_id, t('order.attributes.order_id.not_found')) unless @order
      end

      # active order method found in order model
      def valid_order_status
        errors.add(:order_status, t('order.order_status')) unless @order && @order.active_order?
      end

      def shipment_available?
        return unless @school && @order

        errors.add(:shipment_limit_exceeds, t('order.shipment_limit_exceeds')) if shipment_quota_exceeds?
      end

      def shipment_quota_exceeds?
        gifts_shipped_today + @order.gifts_amount > 60
      end

      def gifts_shipped_today(gifts_shipped = 0)
        orders_shipped_today.map{ |order| gifts_shipped += order.gifts_amount}
        gifts_shipped
      end

      def orders_shipped_today
        @school.orders.where(
          shipped_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day,
          status: :order_shipped
        )
      end
    end
  end
end