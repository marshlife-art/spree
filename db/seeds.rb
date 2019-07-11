# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

Spree::Gateway::Bogus.where(
  name: 'Credit Card',
  description: 'Bogus payment gateway.',
  active: true
).first_or_create!

Spree::PaymentMethod::Check.where(
  name: 'Check',
  description: 'Pay by check.',
  active: true
).first_or_create!

begin
  north_america = Spree::Zone.find_by!(name: 'North America')
rescue ActiveRecord::RecordNotFound
  puts 'Couldn\'t find \'North America\' zone. Did you run `rake db:seed` first?'
  puts 'That task will set up the countries, states and zones required for Spree.'
  exit
end

shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')

shipping_methods = [
  {
    name: 'Pickup',
    zones: [north_america],
    display_on: 'both',
    shipping_categories: [shipping_category]
  },
  {
    name: 'Delivery',
    zones: [north_america],
    display_on: 'both',
    shipping_categories: [shipping_category]
  }
]

shipping_methods.each do |attributes|
  Spree::ShippingMethod.where(name: attributes[:name]).first_or_create! do |shipping_method|
    shipping_method.calculator = Spree::Calculator::Shipping::FlatRate.create!
    shipping_method.zones = attributes[:zones]
    shipping_method.display_on = attributes[:display_on]
    shipping_method.shipping_categories = attributes[:shipping_categories]
  end
end

{
  'Pickup' => [0, 'USD'],
  'Delivery' => [10, 'USD']
}.each do |shipping_method_name, (price, currency)|
  shipping_method = Spree::ShippingMethod.find_by!(name: shipping_method_name)
  shipping_method.calculator.preferences = {
    amount: price,
    currency: currency
  }
  shipping_method.calculator.save!
  shipping_method.save!
end

Spree::StoreCreditCategory.find_or_create_by!(name: 'Default')

north_america = Spree::Zone.find_by!(name: 'North America')
food = Spree::TaxCategory.first_or_create!(name: 'Food')
Spree::TaxRate.where(
  name: 'North America',
  zone: north_america,
  amount: 0.01225,
  tax_category: food
).first_or_create! do |tax_rate|
  tax_rate.calculator = Spree::Calculator::DefaultTax.create!
end

nonfoods = Spree::TaxCategory.first_or_create!(name: 'Non-Foods')
Spree::TaxRate.where(
  name: 'North America',
  zone: north_america,
  amount: 0.08113,
  tax_category: nonfoods
).first_or_create! do |tax_rate|
  tax_rate.calculator = Spree::Calculator::DefaultTax.create!
end
