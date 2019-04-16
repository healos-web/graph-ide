class ChangeArcsTableAndAddCoordinatesToNodesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :arcs, :weight, :string
    remove_column :nodes, :form, :string
    add_column :nodes, :x, :decimal
    add_column :nodes, :y, :decimal
  end
end