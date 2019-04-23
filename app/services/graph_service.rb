class GraphService
  TYPE_COMMON = 'common'.freeze

  class << self
    def get_adjacency_matrix(nodes, arcs)
      matrix = []
      nodes.each do |start_node|
        string = []
        nodes.each do |finish_node|
          adjacency_nodes_for_matrix?(arcs, start_node, finish_node) ? string.push(1) : string.push(0)
        end
        matrix.push(string)
      end
      matrix
    end

    def full?(matrix)
      matrix.each_index do |i|
        matrix[i].each_index do |j|
          return false if matrix[i][j].zero? && i != j
        end
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

    def find_hamiltonyan_cycles(graph)
      matrix = get_adjacency_matrix(graph.nodes, graph.arcs)
      cycles = []
      path = []
      matrix.length.times { |i| find_path(copy(path, i), matrix, cycles) }
      cycles
    end

    def adjacency_nodes?(matrix, start_node, finish_node)
      matrix[start_node][finish_node] == 1
    end


    def find_path(path, matrix, cycles)
      matrix.length.times do |j|
        if !path.include?(j) && adjacency_nodes?(matrix, path.last, j) && j != path.first
          find_path(copy(path, j), matrix, cycles)
        end
        if path.length == matrix.length && adjacency_nodes?(matrix, j, path.first)
          cycles.push(copy(path, path.first))
          break
        end
      end
    end

    def cartesian_product_matrix(graph1, graph2)
      matrix1 = get_adjacency_matrix(graph1.nodes, graph2.arcs)
      matrix2 = get_adjacency_matrix(graph2.nodes, graph2.arcs)
      nodes = get_product_nodes(matrix1, matrix2)
      cartesian_matrix = []
      nodes.each do |start_node|
        string = []
        nodes.each do |finish_node|
          if (start_node.first == finish_node.first &&
             matrix2[start_node.last][finish_node.last] == 1) ||
             (matrix1[start_node.first][finish_node.first] == 1 &&
               start_node.last == finish_node.last)
            string.push(1)
          else
            string.push(0)
          end
        end
        cartesian_matrix.push(string)
      end
      cartesian_matrix
    end

    def vector_product_matrix(graph1, graph2)
      matrix1 = get_adjacency_matrix(graph1.nodes, graph2.arcs)
      matrix2 = get_adjacency_matrix(graph2.nodes, graph2.arcs)
      nodes = get_product_nodes(matrix1, matrix2)
      vector_matrix = []
      nodes.each do |start_node|
        string = []
        nodes.each do |finish_node|
          if matrix2[start_node.last][finish_node.last] == 1 && matrix1[start_node.first][finish_node.first] == 1
            string.push(1)
          else
            string.push(0)
          end
        end
        vector_matrix.push(string)
      end
      vector_matrix
    end

    private

    def get_product_nodes(matrix1, matrix2)
      new_matrix = []
      matrix1.length.times do |u|
        matrix2.length.times do |v|
          new_matrix.push([u, v])
        end
      end
      new_matrix
    end

    def copy(array, *arg)
      new_array = Array.new
      array.each { |elem| new_array.push(elem) }
      new_array + arg
    end

    def adjacency_nodes_for_matrix?(arcs, start_node, finish_node)
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