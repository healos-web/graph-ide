class GraphsController < ApplicationController
  before_action :find_graph, extend: %i[create autocomplete open calcul_cartesian_product calcul_vector_product]
  respond_to :js

  def index
    @graphs = Graph.all.map { |graph| [graph.name, graph.id] }
    @path = "/graphs/calcul_#{params[:product]}_product"
  end

  def create
    @graph = Graph.create
    @graph.name = new_graph_name(@graph.id)
    @graph.save(validate: false)
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
    calcul_qualities if @graph
    render 'create' if @graph
  end

  def close
    render 'destroy'
  end

  def copy_to_clipboard
    session[:clipboard] = params[:selected]
    head :no_content
  end

  def clipboard_data
    if session[:clipboard]
      session[:clipboard]['nodes'].each do |num_hash|
        node = num_hash.last
        @graph.nodes.create(name: node['id'], x: node['x'].to_i, y: node['y'].to_i, color: node['color'])
      end
      session[:clipboard]['arcs']&.each do |num_hash|
        arc = num_hash.last
        if (start_node = @graph.nodes.find_by(name: arc['start_id'])) && (finish_node = @graph.nodes.find_by(name: arc['finish_id']))
          @graph.arcs.create(start_node: start_node, finish_node: finish_node, color: arc['color'], arc_type: arc['arc_type'])
        end
      end
      session[:clipboard]['nodes'].each do |num_hash|
        node = num_hash.last
        @graph.nodes.find_by(name: node['id']).update(name: node['name'])
      end
      calcul_qualities
    end
    render 'show'
  end

  def to_full
    arcs = @graph.arcs
    nodes = @graph.nodes
    matrix = GraphService.get_adjacency_matrix(nodes, arcs)
    arcs.each do |arc|
      arc.update(arc_type: 'common')
    end
    nodes.length.times do |start_node|
      nodes.length.times do |finish_node|
        unless GraphService.adjacency_nodes?(matrix, start_node, finish_node)
          @graph.arcs.create(start_node: nodes[start_node], finish_node: nodes[finish_node], arc_type: 'common') if start_node != finish_node
        end
      end
    end
    render 'show_ajax'
  end

  def find_hamiltonyan_cycles
    @cycles = GraphService.find_hamiltonyan_cycles(@graph)
    @string_cycles = []
    nodes = @graph.nodes
    @cycles.each do |cycle|
      string = ''
      cycle.each do |node_index|
        string += " => #{nodes[node_index].name} (#{nodes[node_index].id})"
      end
      @string_cycles.push(string)
    end
  end

  def calcul_cartesian_product
    @graph1 = Graph.find_by(id: params[:first_graph_id])
    @graph2 = Graph.find_by(id: params[:second_graph_id])
    cartesian_matrix = GraphService.cartesian_product_matrix(@graph1, @graph2)
    @graph = create_graph_by_matrix(cartesian_matrix)
    calcul_qualities
    render 'create'
  end

  def calcul_vector_product
    @graph1 = Graph.find_by(id: params[:first_graph_id])
    @graph2 = Graph.find_by(id: params[:second_graph_id])
    vector_matrix = GraphService.vector_product_matrix(@graph1, @graph2)
    @graph = create_graph_by_matrix(vector_matrix)
    calcul_qualities
    render 'create'
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

  def create_graph_by_matrix(matrix)
    start_x = 200
    start_y = 200
    graph = Graph.create
    graph.name = new_graph_name(graph.id)
    graph.save(validate: false)
    matrix.length.times do |t|
      graph.nodes.create(x: start_x, y: start_y, name: "node #{t + 1}")
      start_x < 800 ? start_x += 100 : start_x -= 100
      start_y < 600 ? start_y += 50 : start_y -= 50
    end
    nodes = graph.nodes
    matrix.length.times do |i|
      matrix.length.times do |j|
        if matrix[i][j] == 1
          if arc = graph.arcs.find_by(start_node: nodes[j], finish_node: nodes[i])
            arc.update(arc_type: 'common')
          else
            graph.arcs.create(arc_type: 'oriented', start_node: nodes[i], finish_node: nodes[j])
          end
        end
      end
    end
    graph
  end

  def node_params
    params[:name]
  end

  def calcul_qualities
    @matrix = GraphService.get_adjacency_matrix(@graph.nodes, @graph.arcs)
    eccentricities = GraphService.find_eccentricities(@matrix)
    @radius = GraphService.get_radius(eccentricities)
    @diameter = GraphService.get_diameter(eccentricities)
    @center = GraphService.get_center(eccentricities, @graph.nodes)
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
