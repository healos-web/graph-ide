class Arc < ApplicationRecord
  extend Enumerize
  belongs_to :graph
  belongs_to :start_node,
             class_name: 'Node',
             counter_cache: :leaving_arcs_count
  belongs_to :finish_node,
             class_name: 'Node',
             counter_cache: :incoming_arcs_count

  enumerize :arc_type, in: %i[oriented common], default: :common
end
