class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :task_id, null: false
      t.integer :user_id, null: false
      t.string :action, null: false
      t.text :details
      t.datetime :notification_sent_at

      t.timestamps
    end

    add_index :notifications, :task_id
    add_index :notifications, :user_id
  end
end
