class Node < ApplicationRecord
  belongs_to :graph
  has_many :leaving_arcs, class_name: 'Arc', foreign_key: :start_node_id, dependent: :destroy
  has_many :incoming_arcs, class_name: 'Arc', foreign_key: :finish_node_id, dependent: :destroy
  validates :name,
            uniqueness: { scope: :graph },
            on: :update
end
