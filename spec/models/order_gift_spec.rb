require 'rails_helper'

RSpec.describe OrderGift, type: :model do
  it { should belong_to :order }
  it { should belong_to :gift }
end
