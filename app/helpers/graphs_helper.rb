module GraphsHelper
  include NodesHelper
  def unique_node?
    special_length?(arcs: 0, nodes: 1)
  end

  def unique_arc?
    special_length?(arcs: 1, nodes: 0)
  end

  def any_elements?
    @nodes.length.positive? || @arcs.length.positive?
  end

  def special_length?(arcs:, nodes:)
    return false unless check_elements?

    @nodes.length == nodes && @arcs.length == arcs
  end

  def color
    colors = (@nodes + @arcs).map { |object| object['color'] }
    colors.uniq.length > 1 ? '#000000' : colors.first
  end

  def nodes_id
    @nodes.map { |node| node['id'] }
  end

  def arcs_id
    @arcs.map { |arc| arc['id'] }
  end

  def check_elements?
    @nodes && @arcs ? true : false
  end
end
