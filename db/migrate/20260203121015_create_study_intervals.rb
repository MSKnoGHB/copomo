class CreateStudyIntervals < ActiveRecord::Migration[6.1]
  def change
    create_table :study_intervals do |t|
      t.references :study_record, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at
      t.timestamps
    end
  end
end
