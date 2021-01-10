module V1
  class OrdersController
    # Destroy controller action validator
    class DestroyValidator < BaseValidator
      attr_accessor :school_id, :order_id

      before_validation :find_school, :find_order

      validate :school_exists,
               :order_exists,
               :valid_order_status

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
    end
  end
end