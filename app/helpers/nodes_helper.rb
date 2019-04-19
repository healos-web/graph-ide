module NodesHelper
  TYPE_COMMON = 'common'.freeze
  def calcul_power(node)
    node.leaving_arcs.count + node.incoming_arcs.where(arc_type: TYPE_COMMON).count
  end
end
