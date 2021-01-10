class Gift < ApplicationRecord
  enum gift_type: %i[mug t_shirt hoodie sticker]

  has_many :order_gifts, dependent: :destroy
  has_many :orders, through: :order_gifts
end
