class Node < ApplicationRecord
  extend Enumerize
  belongs_to :graph
end
