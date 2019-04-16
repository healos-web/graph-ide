class CreateNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nodes do |t|
      t.string :form, default: 'circle'
      t.string :color, default: '#000000'
      t.string :name
      t.references :graph
      t.timestamps
    end
  end
end
