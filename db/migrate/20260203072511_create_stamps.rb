class CreateStamps < ActiveRecord::Migration[6.1]
  def change
    create_table :stamps do |t|
      t.string :stamp_name, null: false
      t.boolean :is_active, null: false, default: true, index: true
      t.timestamps
    end
  end
end
