# Recipient model
# first_name:string
# last_name:string
# address:string
class Recipient < ApplicationRecord
  belongs_to :school
end
