class GraphsController < ApplicationController
  before_action :find_graph, extend: %i[create autocomplete open]
  respond_to :js

  def create
    @graph = Graph.create
    @graph.update(name: "New graph #{@graph.id}")
  end

  def update
    @graph.update(params.require(:graph).permit(:name))
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
    params[:nodes]&.map { |id| find_node(id).update(color: params[:color]) }
    params[:arcs]&.map { |id| find_arc(id).update(color: params[:color]) }
  end

  def delete_elements
    params[:nodes]&.map { |id| find_node(id).destroy }
    params[:arcs]&.map { |id| find_arc(id).destroy }
    render 'show'
  end

  private

  def node_params
    params[:name]
  end

  def find_node(id)
    Node.find_by(id: id)
  end

  def find_arc(id)
    Arc.find_by(id: id)
  end

  def find_graph
    @graph = Graph.find_by(id: params[:id])
  end
end
