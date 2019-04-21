class GraphsController < ApplicationController
  before_action :find_graph, extend: %i[create autocomplete open]
  respond_to :js

  def create
    @graph = Graph.create
    @graph.update(name: new_graph_name(@graph.id))
    calcul_qualities
  end

  def update
    head :no_content unless @graph.update(params.require(:graph).permit(:name))
  end

  def show
    calcul_qualities
  end

  def destroy
    @graph.destroy
  end

  def autocomplete
    render json: Graph.search(params[:name],
                              {
                                limit: 10,
                                load: false,
                                misspellings: { below: 3 }
                              }).map(&:name)
  end

  def open
    @graph = Graph.find_by(name: params[:name])
    render 'create' if @graph
  end

  def close
    render 'destroy'
  end

  def selected_elements
    @nodes = JSON.parse(params[:nodes]) if params[:nodes]
    @arcs = JSON.parse(params[:arcs]) if params[:arcs]
  end

  def update_elements
    find_node(params[:nodes].first).update(name: node_params) if node_params
    find_arc(params[:arcs].first).update(arc_type: arc_params) if arc_params
    params[:nodes]&.map { |id| find_node(id).update(color: params[:color]) }
    params[:arcs]&.map { |id| find_arc(id).update(color: params[:color]) }
  end

  def delete_elements
    params[:nodes]&.map { |id| find_node(id).destroy }
    params[:arcs]&.map { |id| find_arc(id)&.destroy }
    render 'show_ajax'
  end

  private

  def node_params
    params[:name] if params[:name] =~ /\A((?!node \d).)*\z/
  end

  def calcul_qualities
    @matrix = GraphService.get_adjacency_matrix(@graph.nodes, @graph.arcs)
    eccentricities = GraphService.find_eccentricities(@matrix)
    @radius = GraphService.get_radius(eccentricities)
    @diameter = GraphService.get_diameter(eccentricities)
    @center = GraphService.get_diameter(eccentricities)
    @full_graph = GraphService.full?(@matrix)
  end

  def arc_params
    params[:arc_type]
  end

  def find_node(id)
    Node.find_by(id: id)
  end

  def find_arc(id)
    Arc.find_by(id: id)
  end

  def new_graph_name(id)
    "New graph #{id}"
  end

  def find_graph
    @graph = Graph.find_by(id: params[:id])
  end
end
