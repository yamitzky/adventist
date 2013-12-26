class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :url, null: false
      t.integer :user_id, null: false
      t.string :feed_url
      t.string :title

      t.timestamps
    end
    add_index :websites, :user_id
  end
end
