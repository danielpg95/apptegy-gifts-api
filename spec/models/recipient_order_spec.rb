require 'rails_helper'

RSpec.describe RecipientOrder, type: :model do
  it { should belong_to :recipient }
  it { should belong_to :order }
end
