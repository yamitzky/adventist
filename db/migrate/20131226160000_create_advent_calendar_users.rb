class CreateAdventCalendarUsers < ActiveRecord::Migration
  def change
    create_table :advent_calendar_users do |t|
      t.integer :advent_calendar_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
    add_index :advent_calendar_users, [:advent_calendar_id, :user_id], unique:true
  end
end
