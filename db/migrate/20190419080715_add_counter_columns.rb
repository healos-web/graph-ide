class AddCounterColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :nodes, :leaving_arcs_count, :integer
    add_column :nodes, :incoming_arcs_count, :integer
  end
end
