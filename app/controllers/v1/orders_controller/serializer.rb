module V1
  class OrdersController
    # Serializer to return selected class attributes
    class Serializer < ActiveModel::Serializer
      attributes :status, :shipped_at, :recipients, :gifts, :school

      def shipped_at
        I18n.l(object.shipped_at, format: '%d/%B/%Y %H:%M') if object.shipped_at.present?
      end

      # Had trouble making it work with has_many with each_serialize, so a manual approach was used to save time
      def gifts
        object.gifts.map do |recipient|
          GiftSerializer.new(recipient).attributes
        end
      end

      def recipients
        object.recipients.map do |recipient|
          RecipientSerializer.new(recipient).attributes
        end
      end

      def school
        SchoolSerializer.new(object.school).attributes
      end
    end
  end

  class SchoolSerializer < ActiveModel::Serializer
    attributes :name
  end

  class RecipientSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :address
  end

  class GiftSerializer < ActiveModel::Serializer
    attributes :gift_type
  end
end