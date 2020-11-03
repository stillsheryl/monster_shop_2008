# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
bell = bike_shop.items.create(name: "Silver Bell", description: "Let everyone know you're coming!", price: 25, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
kickstand = bike_shop.items.create(name: "Kickstand", description: "Don't fall!", price: 75, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 4)
helmet = bike_shop.items.create(name: "Helmet", description: "Protect your head!", price: 150, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 20)
streamers = bike_shop.items.create(name: "streamers", description: "Everyone will see you coming!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 15)
seat = bike_shop.items.create(name: "Seat", description: "Protect your bum!", price: 90, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 7)


#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
spring = dog_shop.items.create(name: "Spring Toy", description: "Best thing to chase", price: 7, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 53)
leash = dog_shop.items.create(name: "Leash", description: "Walk that dog!", price: 15, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 41)
octopus = dog_shop.items.create(name: "Plush Octopus Toy", description: "Your dog will love this thing", price: 32, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 12)

#users
kiera = User.create!(name: 'Kiera Allen', address: '124 Main St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@marley.com', password: 'password', role: 0)

sally = User.create!(name: 'Sally Peach', address: '432 Grove St.', city: 'Denver', state: 'CO', zip: 80205, email: 'sally@peach.com', password: 'password', role: 1)

bob = User.create!(name: 'Bob Ross', address: '745 Rose St.', city: 'Denver', state: 'CO', zip: 80205, email: 'bob@ross.com', password: 'password', role: 2)

tim = User.create!(name: 'Tim Tyrell', address: '421 Branch St.', city: 'Denver', state: 'CO', zip: 80205, email: 'you_hate@to_see_it.com', password: 'password', role: 0)

# orders

order1 = kiera.orders.create!(name: kiera.name, address: kiera.address, city: kiera.city, state: kiera.state, zip: kiera.zip)
order1.item_orders.create!([{ item: tire, quantity: 2, price: tire.price }, { item: bell, quantity: 1, price: bell.price }, { item: helmet, quantity: 1, price: helmet.price }])

order2 = kiera.orders.create!(name: kiera.name, address: kiera.address, city: kiera.city, state: kiera.state, zip: kiera.zip)
order2.item_orders.create!([{ item: pull_toy, quantity: 2, price: pull_toy.price }, { item: dog_bone, quantity: 3, price: dog_bone.price }, { item: spring, quantity: 1, price: spring.price }])

order3 = tim.orders.create!(name: tim.name, address: tim.address, city: tim.city, state: tim.state, zip: tim.zip)
order3.item_orders.create!(item: tire, quantity: 2, price: tire.price)
