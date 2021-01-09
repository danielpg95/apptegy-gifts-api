module V1
  class SchoolsController
    # Create controller action validator
    class CreateValidator < BaseValidator
      attr_accessor :name, :address

      validates :name, :address, presence: true
      
      # We are not inside the School model, so we need to do a manual verification instead of
      # using uniqueness validation method
      validate :name_uniqueness, :address_uniqueness

      private

      def name_uniqueness
        errors.add(:name, t('school.attributes.name.taken')) if School.find_by(name: name)
      end

      def address_uniqueness
        errors.add(:address, t('school.attributes.address.taken')) if School.find_by(address: address)
      end
    end
  end
end