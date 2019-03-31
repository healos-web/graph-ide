class Arc < ApplicationRecord
  extend Enumerize
  belongs_to :graph

  enumerize :form, in: %i[oriented common], default: :common
end
