FactoryBot.define do
  factory :item do
    name { Faker::Drone.name }
    description { Faker::Address.street_address }
    price { rand(1..150) }
    image { Faker::LoremFlickr.image}
    inventory { rand(1..500) }
  end
end
