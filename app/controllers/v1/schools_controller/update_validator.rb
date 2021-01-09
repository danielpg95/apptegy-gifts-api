module V1
  class SchoolsController
    # Update controller action validator
    class UpdateValidator < BaseValidator
      attr_accessor :id, :name, :address

      before_validation :find_school

      validates :id, :name, :address, presence: true
      
      # We are not inside the School model, so we need to do a manual verification instead of
      # using uniqueness validation method
      validate :school_exists
      validate :name_uniqueness, :address_uniqueness

      private

      def find_school
        @school = School.find_by(id: id)
      end

      def school_exists
        errors.add(:id, t('school.attributes.id.not_found')) unless @school
      end

      def name_uniqueness
        return unless @school

        existing_school = School.find_by(name: name)
        errors.add(:name, t('school.attributes.name.taken')) if existing_school && existing_school.id != @school.id
      end

      def address_uniqueness
        return unless @school

        existing_school = School.find_by(address: address)
        errors.add(:address, t('school.attributes.address.taken')) if (existing_school &&
                                                                        existing_school.id != @school.id)
      end
    end
  end
end