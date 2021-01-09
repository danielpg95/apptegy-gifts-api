FactoryBot.define do
  factory :recipient do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    address { Faker::Address.full_address }
    enabled { true }
    school { nil }
  end
end
