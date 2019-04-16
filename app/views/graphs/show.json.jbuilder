json.nodes @graph.nodes do |node|
  json.id node.id
  json.name node.name
  json.color node.color
  json.x node.x
  json.y node.y
end

json.arcs @graph.arcs.includes(:nodes) do |arc|
  json.color arc.color
  json.type arc.type
  json.id arc.id
  json.start_node_id arc.start_node.id
  json.finish_node_id arc.finish_node.id
end