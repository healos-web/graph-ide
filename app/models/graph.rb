class Graph < ApplicationRecord
  has_many :nodes, dependent: :destroy
  has_many :arcs, dependent: :destroy

  validates :name, presence: true, uniqueness: true, on: :update

  searchkick
  def search_data
    {
      name: name
    }
  end
end
