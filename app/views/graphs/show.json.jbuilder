json.nodes @graph.nodes do |node|
  json.id node.id
  json.name node.name
  json.color node.color
  json.x node.x
  json.y node.y
end

json.graph_id @graph.id

json.arcs @graph.arcs do |arc|
  json.color arc.color
  json.arc_type arc.arc_type
  json.id arc.id
  json.start_x arc.start_node.x
  json.start_y arc.start_node.y
  json.start_id arc.start_node.id
  json.finish_x arc.finish_node.x
  json.finish_y arc.finish_node.y
  json.finish_id arc.finish_node.id
end