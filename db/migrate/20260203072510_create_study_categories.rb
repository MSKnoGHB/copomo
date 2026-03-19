class CreateStudyCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :study_categories do |t|
      t.string :category_title, null: false, index: true
      t.text :category_body
      t.boolean :is_active, null: false, default: true, index: true
      t.timestamps
    end
  end
end
