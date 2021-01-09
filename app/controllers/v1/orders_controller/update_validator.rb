module V1
  class OrdersController
    # Update controller action validator
    class UpdateValidator < BaseValidator
      attr_accessor :school_id, :order_id, :recipient_ids, :gift_types

      before_validation :find_school, :find_order, :find_recipients, :find_gifts

      validate :school_exists,
               :order_exists,
               :recipients_exists,
               :gift_types_exists,
               :valid_order_status,
               :validate_order_size

      private

      def find_school
        @school = School.find_by(id: school_id)
      end

      def find_order
        return unless @school

        @order = @school.orders.find_by(id: order_id)
      end

      def find_recipients
        return unless @school

        @recipients = @school.recipients.where(id: recipient_ids, enabled: true)
      end

      def find_gifts
        @gifts = Gift.where(gift_type: gift_types) if valid_gift_types?
      end

      def school_exists
        errors.add(:school_id, t('order.attributes.school_id.not_found')) unless @school
      end

      def order_exists
        errors.add(:order_id, t('order.attributes.order_id.not_found')) unless @order
      end

      def recipients_exists
        errors.add(:recipient_ids, t('order.attributes.recipient_ids.missing')) unless
          @recipients.present? && @recipients.count == recipient_ids.count
      end
      
      def gift_types_exists
        errors.add(:gift_types, t('order.attributes.gift_types.invalid_type')) unless
          @gifts.present? && @gifts.count == gift_types.count
      end

      # active order method found in order model
      def valid_order_status
        errors.add(:order_status, t('order.order_status')) unless @order && @order.active_order?
      end

      def validate_order_size
        errors.add(:order_limit_exceeded, t('order.order_limit_exceeded')) if order_limit_exceeded?
      end

      def order_limit_exceeded?
        return true if recipient_ids.nil? || gift_types.nil?

        (recipient_ids.count * gift_types.count) > 60
      end

      def valid_gift_types?
        return if gift_types.nil?

        (gift_types - Gift.gift_types.keys).empty?
      end
    end
  end
end