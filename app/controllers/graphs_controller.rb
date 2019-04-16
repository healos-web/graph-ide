class GraphsController < ApplicationController
  before_action :find_graph, only: %i[update destroy close show]
  respond_to :js

  def create
    @graph = Graph.create
    @graph.update(name: "New graph #{@graph.id}")
  end

  def update
    @graph.update(params.require(:graph).permit(:name))
  end

  def show
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
    render template: 'graphs/create.js.slim' if @graph
  end

  def close
    render template: 'graphs/destroy.js.slim'
  end

  def create_several
  end

  private

  def find_graph
    @graph = Graph.find_by(id: params[:id])
  end
end
