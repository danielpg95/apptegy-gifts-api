module V1
  class SchoolsController
    # Serializer to return selected class attributes
    class Serializer < ActiveModel::Serializer
      attributes :name, :address
    end
  end
end