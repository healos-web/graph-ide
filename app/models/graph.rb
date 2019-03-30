class Graph < ApplicationRecord
  has_many :nodes, dependent: :destroy
  has_many :arcs, dependent: :destroy

  validates :name, allow_blank: false
end
