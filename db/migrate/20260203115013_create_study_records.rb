class CreateStudyRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :study_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_room, null: false, foreign_key: true
      t.references :study_theme, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.integer :total_focus_minutes
      t.integer :study_status, null: false, default: 0, index: true
      t.text :record_body
      t.boolean :is_publish, null: false, default: true, index: true
      t.timestamps
    end
  end
end
