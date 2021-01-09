FactoryBot.define do
  factory :school do
    name { Faker::Name.name }
    address { Faker::Address.full_address }
  end
end
