class CreateChatLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_logs do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :stamp, foreign_key: true
      t.string :message
      t.integer :message_type, null: false, index: true
      t.boolean :is_active, null: false, default: true, index: true
      t.timestamps
    end
  end
end
