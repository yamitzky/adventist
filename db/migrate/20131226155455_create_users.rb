class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :image_url
      t.string :provider, null: false

      t.timestamps
    end
  end
end
