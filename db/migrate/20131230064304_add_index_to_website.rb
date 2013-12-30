class AddIndexToWebsite < ActiveRecord::Migration
  def change
    add_index :websites, [:user_id, :url], unique: true
  end
end
