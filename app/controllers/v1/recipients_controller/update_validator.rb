module V1
  class RecipientsController
    # Create controller action validator
    class UpdateValidator < BaseValidator
      attr_accessor :first_name, :last_name, :address, :school_id, :id

      before_validation :find_school, :find_recipient

      validates :first_name, :last_name, :address, presence: true
      validate :school_exists, :recipient_exists

      # Validations for uniqueness may cause problems with people with the same name that live in the same address
      # so it is ommited

      private

      def find_school
        @school = School.find_by(id: school_id)
      end

      def school_exists
        errors.add(:school_id, t('recipient.attributes.school_id.not_found')) unless @school
      end

      def find_recipient
        return unless @school

        @recipient = @school.recipients.find_by(id: id)
      end

      def recipient_exists
        errors.add(:id, t('recipient.attributes.id.not_found')) unless @recipient
      end
    end
  end
end