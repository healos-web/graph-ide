class Node < ApplicationRecord
  extend Enumerize
  belongs_to :graph

  enumerize :form, in: %i[circle triangle square hexagon], default: :circle
end
