class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.integer :focus_minutes, null: false
      t.integer :break_minutes, null: false
      t.timestamps
    end
  end
end
