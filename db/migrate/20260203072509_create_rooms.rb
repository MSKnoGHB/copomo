class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :room_name, null: false
      t.integer :focus_minutes, null: false
      t.integer :break_minutes, null: false
      t.timestamps
    end
  end
end
