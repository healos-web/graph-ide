class CreateArcs < ActiveRecord::Migration[5.2]
  def change
    create_table :arcs do |t|
      t.string :type, default: :common
      t.string :color, default: '#000000'
      t.string :weight
      t.references :graph
      t.timestamps
    end
  end
end
