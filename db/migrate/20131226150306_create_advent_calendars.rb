class CreateAdventCalendars < ActiveRecord::Migration
  def change
    create_table :advent_calendars do |t|
      t.string :name, null: false
      t.string :provider, null: false
      t.string :url, null: false

      t.timestamps
    end
    add_index :advent_calendars, :provider
  end
end
