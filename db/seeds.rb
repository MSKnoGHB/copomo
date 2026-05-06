# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#rails db:reset
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Room.destroy_all

Room.find_or_create_by!(room_name: "クイック") do |room|
  room.focus_minutes = 15
  room.break_minutes = 3
  room.cycle_started_at = Time.current
end

Room.find_or_create_by!(room_name: "スタンダード") do |room|
  room.focus_minutes = 25
  room.break_minutes = 5
  room.cycle_started_at = Time.current
end

Room.find_or_create_by!(room_name: "ディープ") do |room|
  room.focus_minutes = 50
  room.break_minutes = 10
  room.cycle_started_at = Time.current
end

Room.find_or_create_by!(room_name: "テスト") do |room|
  room.focus_minutes = 1
  room.break_minutes = 1
  room.cycle_started_at = Time.current
end


StudyCategory.find_or_create_by!(category_title: "学校・受験") do |study_category|
  study_category.category_body = nil
  study_category.is_active = true
end

StudyCategory.find_or_create_by!(category_title: "資格・検定") do |study_category|
  study_category.category_body = nil
  study_category.is_active = true
end

StudyCategory.find_or_create_by!(category_title: "仕事・作業") do |study_category|
  study_category.category_body = nil
  study_category.is_active = true
end


