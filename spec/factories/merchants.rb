FactoryBot.define do
  factory :merchant do
    name: { Faker::Name.name }
    address: { Faker::Address.street_address }
    city: { Faker::Address.city_prefix }
    state: { Faker::Address.state_abbr }
    zip: { Faker::Address.zip }
  end
end
