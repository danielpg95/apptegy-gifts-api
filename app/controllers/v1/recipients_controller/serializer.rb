module V1
  class RecipientsController
    # Serializer to return selected class attributes
    class Serializer < ActiveModel::Serializer
      attributes :first_name, :last_name, :address, :school

      def school
        SchoolSerializer.new(object.school).attributes
      end
    end
  end

  class SchoolSerializer < ActiveModel::Serializer
    attributes :name
  end
end