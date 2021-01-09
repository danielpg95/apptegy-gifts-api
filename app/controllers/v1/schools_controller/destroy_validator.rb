module V1
  class SchoolsController
    # Destroy controller action validator
    class DestroyValidator < BaseValidator
      attr_accessor :id

      before_validation :find_school

      validates :id, presence: true
      validate :school_exists

      private

      def find_school
        @school = School.find_by(id: id)
      end

      def school_exists
        errors.add(:id, t('school.attributes.id.not_found')) unless @school
      end
    end
  end
end