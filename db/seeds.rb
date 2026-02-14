# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Room.destroy_all

Room.create!([
  { room_name: "クイックルーム", focus_minutes: 15, break_minutes: 3 },
  { room_name: "スタンダードルーム", focus_minutes: 25, break_minutes: 5 },
  { room_name: "ディープルーム", focus_minutes:  50, break_minutes: 10 }
])

StudyCategory.create!([
  { category_title: "学校・受験", category_body: nil, is_active: true },
  { category_title: "資格・検定", category_body: nil, is_active: true },
  { category_title: "仕事・作業", category_body: nil, is_active: true }
])