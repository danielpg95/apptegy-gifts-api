require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should respond_to :status }

  it { should belong_to :school }
  it { should have_many :order_gifts }
  it { should have_many :recipient_orders }
end
