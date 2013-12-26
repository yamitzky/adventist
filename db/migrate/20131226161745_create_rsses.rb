class CreateRsses < ActiveRecord::Migration
  def change
    create_table :rsses do |t|
      t.string :url, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :rsses, :user_id
  end
end
