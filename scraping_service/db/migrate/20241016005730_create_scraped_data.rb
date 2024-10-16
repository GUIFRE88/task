class CreateScrapedData < ActiveRecord::Migration[6.1]
  def change
    create_table :scraped_data do |t|
      t.integer :task_id, null: false
      t.string :brand, null: false
      t.string :model, null: false
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
