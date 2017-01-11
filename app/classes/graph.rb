class Graph

  attr_accessor :node_list
  attr_accessor :edges

  # Graph is a hash of nodes and hash of edges
  def initialize(node_list = Hash.new, edges = Hash.new)
    @node_list = node_list
    @edges = edges
  end

  def add_node(node)
    @node_list[node.node_data] = node
  end

  def find_node_by_element(element)
    return @node_list[element]
  end

  def add_undirected_edge(node_from, node_to, weight)
    edge1 = Edge.new(node_from, node_to, weight)
    edge2 = Edge.new(node_to, node_from, weight)

    # edge1 and edge2 used as checks to prevent duplicate edges between two nodes
    # since this is an undirected graph, only add edge1 (edge2 is just for a check)
    if !@edges.has_key?(edge1.hash_key) && !@edges.has_key?(edge2.hash_key)

      @node_list[node_from.node_data].add_neighbor(node_to)
      @node_list[node_from.node_data].add_edge(edge1)

      @node_list[node_to.node_data].add_neighbor(node_from)
      @node_list[node_to.node_data].add_edge(edge1)

      @edges[edge1.hash_key] = weight
    end

  end

  def add_directed_edge(node_from, node_to, weight)
    edge = Edge.new(node_from, node_to, weight)
    @edges[edge.hash_key] = weight

    @node_list[node_from.node_data].add_neighbor(node_to)
    @node_list[node_from.node_data].add_edge(edge)
  end


  def update_all_nodes_to_distance(distance)
    @node_list.values.each do |node|
      node.key = distance
    end
  end

  def print_graph
    puts 'printing graph'
    @node_list.values.each do |node|
      puts 'Node (' + node.node_data.to_s + ')'
      puts 'nodes neighbors: '
      node.neighbors.each_with_index do |neighbor, index|
        puts neighbor.node_data.to_s + ' edge ' + index.to_s + ' ' + neighbor.edges[index].to_s
      end
    end
  end

  def minimum_spanning_tree
    mst = PrimMinimumSpanningTree.new(self)
    return mst.minimum_spanning_tree
  end

  def minimum_spanning_tree_edges(edges)
    mst_edges = []
    unless edges.nil?
      edges.each do |edge|
        mst_edge = MstEdge.new(edge.node1.node_data.name.to_s, edge.node2.node_data.name.to_s, edge.weight)
        mst_edges << mst_edge
      end
    end
    return mst_edges
  end

end