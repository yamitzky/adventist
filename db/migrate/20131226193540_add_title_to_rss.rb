class AddTitleToRss < ActiveRecord::Migration
  def change
    add_column :rsses, :title, :string
  end
end
