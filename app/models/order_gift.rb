class OrderGift < ApplicationRecord
  belongs_to :order
  belongs_to :gift
end
