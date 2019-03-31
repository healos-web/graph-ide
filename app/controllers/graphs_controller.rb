class GraphsController < ApplicationController
  before_action :find_graph, only: %i[update destroy]
  respond_to :js

  def create
    @graph = Graph.create(name: 'New graph')
    respond_with 'create.js.slim'
  end

  def update
    @graph.update(name: params.require(:graph).permit(:name))
    respond_with 'update.js.slim'
  end

  def destroy
    @graph.destroy
    respond_with 'destroy.js.slim'
  end

  def create_several
  end

  private

  def find_graph
    @graph = Graph.find_by(id: params[:id])
  end
end
