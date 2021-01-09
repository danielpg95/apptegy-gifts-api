require 'rails_helper'

RSpec.describe Recipient, type: :model do
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :address }

  it { should belong_to :school }
end
