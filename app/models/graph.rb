class Graph < ApplicationRecord
  has_many :nodes, dependent: :destroy
  has_many :arcs, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true,
            format: /\A((?!New graph \d).)*\z/,
            on: :update

  searchkick
  def search_data
    {
      name: name
    }
  end
end
