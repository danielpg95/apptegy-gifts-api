require 'rails_helper'

RSpec.describe Gift, type: :model do
  it { should respond_to :gift_type }

  it { should have_many :order_gifts }
end
