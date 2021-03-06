# Recipient model
# first_name:string
# last_name:string
# address:string
# enabled:boolean
# enabled attribute is used to disable users instead of deleting,
# so we can still have access to a complete gifts and orders history
class Recipient < ApplicationRecord
  belongs_to :school

  has_many :recipient_orders, dependent: :destroy
  has_many :orders, through: :recipient_orders
end
