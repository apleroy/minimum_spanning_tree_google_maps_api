class GraphBuilder

  def build_graph(object_list)
    graph = Graph.new
    object_list.each do |object|
      node = Node.new(node_data: object)
      graph.add_node(node)
    end
    return graph
  end


end