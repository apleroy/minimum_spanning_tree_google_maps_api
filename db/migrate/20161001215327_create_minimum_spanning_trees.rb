class CreateMinimumSpanningTrees < ActiveRecord::Migration
  def change
    create_table :minimum_spanning_trees do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
