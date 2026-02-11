class CreateRoomAccesses < ActiveRecord::Migration[6.1]
  def change
    create_table :room_accesses do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :study_theme, foreign_key: true
      t.datetime :entry_time, null: false
      t.datetime :exit_time
      t.integer :study_status, null: false, default: 0, index: true
      t.boolean :is_active, null: false, default: true, index: true
      t.integer :exit_type, index: true 
      t.timestamps
    end
  end
end
