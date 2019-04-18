module GraphHelper
  def unique_node?
    return false unless check_elements?

    @nodes.length == 1 && @arcs.length.zero? ? true : false
  end

  def unique_arc?
    return false unless check_elements?

    @nodes.length.zero? && @arcs.length == 1 ? true : false
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

  private

  def check_elements?
    @nodes && @arcs ? true : false
  end
end
