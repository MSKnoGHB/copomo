class CreateStudyThemes < ActiveRecord::Migration[6.1]
  def change
    create_table :study_themes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_category, null: false, foreign_key: true
      t.string :theme_title, null: false
      t.text :theme_body
      t.string :theme_color, null: false
      t.boolean :is_active, null: false, default: true, index: true
      t.timestamps
    end
  end
end
