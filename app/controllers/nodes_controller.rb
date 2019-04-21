class NodesController < ApplicationController
  DEFAULT_POINT_X = 100
  DEFAULT_POINT_Y = 100
  def create
    find_graph
    node = @graph.nodes.create(x: DEFAULT_POINT_X, y: DEFAULT_POINT_Y)
    node.update(name: new_node_name(node.id))
    render 'graphs/show_ajax'
  end

  def update
    find_node
    @node.update(params_node)
  end

  private

  def find_node
    @node = Node.find(params[:id])
  end

  def new_node_name(id)
    "node #{id}"
  end

  def params_node
    params.require(:node).permit(:x, :y)
  end

  def find_graph
    @graph = Graph.find(params[:graph_id])
  end
end
