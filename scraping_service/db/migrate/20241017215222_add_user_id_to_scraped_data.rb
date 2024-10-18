class AddUserIdToScrapedData < ActiveRecord::Migration[6.1]
  def change
    add_column :scraped_data, :user_id, :integer
  end
end
