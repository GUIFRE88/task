class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :url, null: false
      t.string :status, null: false, default: 'pending'
      t.timestamps
    end
  end
end
