class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :minimum_spanning_tree_id
      t.string :name
      t.timestamps null: false
    end
  end
end
