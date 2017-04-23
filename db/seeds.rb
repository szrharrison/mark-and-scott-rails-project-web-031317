# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
categories = %w(Nature People Abstract Animals Art/Architecture Illustrations/Clipart Technology Objects Travel Food Fashion/Style Landscapes Science Sports/Fitness Still-Life Black/White Color Religion)

categories.each do |category_name|
  Category.find_or_create_by( name: category_name )
end
