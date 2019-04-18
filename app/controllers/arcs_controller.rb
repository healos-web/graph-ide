class ArcsController < ApplicationController
  before_action :find_graph

  def create
    unless check_double_arc
      @graph.arcs.create(arc_type: params[:arc_type],
                         start_node_id: params[:start_node_id],
                         finish_node_id: params[:finish_node_id])
    end
    render template: 'graphs/show.js.slim'
  end

  private

  def find_graph
    @graph = Graph.find(params[:graph_id])
  end

  def check_double_arc
    Arc.find_by(start_node_id: params[:start_node_id],
                finish_node_id: params[:finish_node_id]) ||
      Arc.find_by(start_node_id: params[:finish_node_id],
                  finish_node_id: params[:start_node_id])
  end
end
