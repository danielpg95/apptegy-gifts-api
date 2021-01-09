# School model
# name:string
# address:string
class School < ApplicationRecord
  has_many :recipients, dependent: :destroy
  has_many :orders, dependent: :destroy
end
