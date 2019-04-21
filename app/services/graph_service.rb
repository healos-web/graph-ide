class GraphService
  TYPE_COMMON = 'common'.freeze

  class << self
    def get_adjacency_matrix(nodes, arcs)
      matrix = []
      nodes.each do |start_node|
        string = []
        nodes.each do |finish_node|
          adjacency_nodes?(arcs, start_node, finish_node) ? string.push(1) : string.push(0)
        end
        matrix.push(string)
      end
      matrix
    end

    def full?(matrix)
      matrix.each_index do |i|
        matrix[i].delete_at(i)
        return false if matrix[i].include?(0)
      end
      true
    end

    def find_eccentricities(matrix)
      # n - nodes number
      n = matrix.length
      # d - distances
      d = matrix.map { |string| string.map { |number| number.zero? ? Float::INFINITY : number} }
      n.times do |k|
        n.times do |j|
          n.times do |i|
            d[i][j] = [d[i][j], d[i][k] + d[k][j]].min
          end
        end
      end
      # e - eccentricities
      e = Array.new(n) { 0 }
      n.times do |i|
        n.times do |j|
          e[i] = [e[i], d[i][j]].max
        end
      end
      e
    end

    def get_radius(eccentricities)
      eccentricities.min
    end

    def get_center(ecc, nodes)
      center = []
      radius = get_radius(ecc)
      ecc.each_index { |i| center.push(nodes[i]) if ecc[i] == radius }
      center
    end

    def get_diameter(eccentricities)
      eccentricities.max
    end

    private

    def adjacency_nodes?(arcs, start_node, finish_node)
      arc = arcs.find_by(start_node: start_node, finish_node: finish_node)
      if arc
        true
      else
        arc = arcs.find_by(start_node: finish_node, finish_node: start_node)
        arc&.arc_type == TYPE_COMMON
      end
    end
  end
end