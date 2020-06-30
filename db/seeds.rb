# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

product_list_one = ActiveSupport::JSON.decode(File.read('db/MOCK_DATA.json'))
product_list_two = ActiveSupport::JSON.decode(File.read('db/MOCK_DATA1.json'))
product_list_three = ActiveSupport::JSON.decode(File.read('db/MOCK_DATA2.json'))
product_list_four = ActiveSupport::JSON.decode(File.read('db/MOCK_DATA3.json'))
product_list_five = ActiveSupport::JSON.decode(File.read('db/MOCK_DATA4.json'))

product_list = product_list_one + product_list_two + product_list_three + product_list_four + product_list_five

product_list.freeze

product_list.each do |product|
  next unless Product.find_by(title: product['title']).nil?

  product['tags'] = product['tags'].join(',')
  p = Product.new(product)
  p.save
end