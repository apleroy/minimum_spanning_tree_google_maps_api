class AddIndexToPlaces < ActiveRecord::Migration
  def change
    add_index :places, :minimum_spanning_tree_id
  end
end
