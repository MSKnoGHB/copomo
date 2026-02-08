# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Room.destroy_all

Room.create!([
  { name: "クイックルーム", focus_minutes: 15, break_minutes: 3 },
  { name: "スタンダードルーム", focus_minutes: 25, break_minutes: 5 },
  { name: "ディープルーム", focus_minutes: 45, break_minutes: 10 }
])