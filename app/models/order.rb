# Order model
# status: integer (enum)
# shipped_at: datetime
class Order < ApplicationRecord
  enum status: %i[order_received order_processing order_shipped order_cancelled]

  belongs_to :school

  has_many :order_gifts, dependent: :destroy
  has_many :gifts, through: :order_gifts

  has_many :recipient_orders, dependent: :destroy
  has_many :recipients, through: :recipient_orders

  def active_order?
    %w[order_received order_processing].include? status
  end

  # To each recipient, the amount of gifts are sent
  def gifts_amount
    recipients.count * gifts.count
  end
end
