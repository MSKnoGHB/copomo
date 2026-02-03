class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :study_record, null: false, foreign_key: true
      t.string :comment_body, null: false
      t.timestamps
    end
  end
end
