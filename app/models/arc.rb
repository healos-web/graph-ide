class Arc < ApplicationRecord
  extend Enumerize
  belong_to :graph

  enumerize :form, in: %i[oriented common], default: :common
end
