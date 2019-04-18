class Arc < ApplicationRecord
  extend Enumerize
  belongs_to :graph
  belongs_to :start_node, class_name: 'Node'
  belongs_to :finish_node, class_name: 'Node'

  enumerize :arc_type, in: %i[oriented common], default: :common
end
