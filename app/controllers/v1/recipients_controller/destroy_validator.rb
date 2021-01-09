module V1
  class RecipientsController
    # Destroy controller action validator
    class DestroyValidator < BaseValidator
      attr_accessor :school_id ,:id

      before_validation :find_school, :find_recipient

      validates :school_id, :id, presence: true
      validate :school_exists, :recipient_exists

      private

      def find_school
        @school = School.find_by(id: school_id)
      end

      def school_exists
        errors.add(:school_id, t('recipient.attributes.school_id.not_found')) unless @school
      end

      def find_recipient
        return unless @school

        @recipient = @school.recipients.find_by(id: id, enabled: true)
      end

      def recipient_exists
        errors.add(:id, t('recipient.attributes.id.not_found')) unless @recipient
      end
    end
  end
end