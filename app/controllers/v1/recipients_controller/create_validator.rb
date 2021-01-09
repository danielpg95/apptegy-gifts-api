module V1
  class RecipientsController
    # Create controller action validator
    class CreateValidator < BaseValidator
      attr_accessor :first_name, :last_name, :address, :school_id

      before_validation :find_school

      validates :first_name, :last_name, :address, presence: true
      validate :school_exists

      # Validations for uniqueness may cause problems with people with the same name that live in the same address
      # so it is ommited

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