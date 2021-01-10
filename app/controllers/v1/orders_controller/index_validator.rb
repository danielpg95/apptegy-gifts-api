module V1
  class OrdersController
    # Index controller action validator
    class IndexValidator < BaseValidator
      attr_accessor :school_id

      before_validation :find_school

      validates :school_id, presence: true
      validate :school_exists

      private

      def find_school
        @school = School.find_by(id: school_id)
      end

      def school_exists
        errors.add(:school_id, t('recipient.attributes.school_id.not_found')) unless @school
      end
    end
  end
end