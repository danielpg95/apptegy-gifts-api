# School model
# name:string
# address:string
class School < ApplicationRecord
  has_many :recipients, dependent: :destroy
end
