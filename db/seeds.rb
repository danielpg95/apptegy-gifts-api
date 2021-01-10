# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
Gift.find_or_create_by(gift_type: :mug)
Gift.find_or_create_by(gift_type: :t_shirt)
Gift.find_or_create_by(gift_type: :hoodie)
Gift.find_or_create_by(gift_type: :sticker)
User.create(username: 'apptegy', password: 'apptegy', password_confirmation: 'apptegy')
