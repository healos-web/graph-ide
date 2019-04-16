class Arc < ApplicationRecord
  extend Enumerize
  belongs_to :graph
  has_one :node, as: :start_node, through: :graph
  has_one :node, as: :finish_node, through: :graph

  enumerize :type, in: %i[oriented common], default: :common
end
