class CreateArcs < ActiveRecord::Migration[5.2]
  def change
    create_table :arcs do |t|
      t.string :arc_type, default: :common
      t.string :color, default: '#000000'
      t.string :weight
      t.references :graph
      t.references :start_node
      t.references :finish_node
      t.timestamps
    end
  end
end
