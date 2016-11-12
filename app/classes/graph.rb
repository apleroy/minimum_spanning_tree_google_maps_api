class Graph

  INT_MAX = 999999999999
  attr_accessor :node_list
  attr_accessor :edges

  # Graph is a hash of nodes and hash of edges
  def initialize(node_list = Hash.new, edges = Hash.new)
    @node_list = node_list
    @edges = edges
  end

  def add_node(node)
    @node_list[node.node_data.name] = node
  end

  def find_node_by_name(name)
    return @node_list[name]
  end

  def add_undirected_edge(node_from, node_to, weight)
    edge = Edge.new(node_from, node_to, weight)
    @edges[edge.hash_key] = weight

    @node_list[node_from.node_data.name].add_neighbor(node_to)
    @node_list[node_from.node_data.name].add_edge(edge)

    @node_list[node_to.node_data.name].add_neighbor(node_from)
    @node_list[node_to.node_data.name].add_edge(edge)
  end

  def add_directed_edge(node_from, node_to, weight)
    edge = Edge.new(node_from, node_to, weight)
    @edges[edge.hash_key] = weight

    @node_list[node_from.node_data.name].add_neighbor(node_to)
    @node_list[node_from.node_data.name].add_edge(edge)
  end

  # --------------

  def prim_mst

    included_nodes = Hash.new
    included_edges = []
    excluded_nodes = Hash.new

    min_heap = MinHeap.new

    @node_list.values.each_with_index do |node, index|
      if index == 0
        node.key = 0
      end
      excluded_nodes[node.node_data.name] = node
      min_heap << node #add node to min_heap (comparable is on key) (log(n))

    end
    min_heap.print_heap


    # while there are nodes not yet in the set
    while excluded_nodes.count > 0

      # find the node that has the minimum key and is in the excluded set
      min_node = min_heap.extract_min # (log(n))

        min_edge = find_min_edge(min_node, min_heap, excluded_nodes)
        puts "min edge returned is " + min_edge.to_s

        included_edges << min_edge unless min_edge.nil?

        included_nodes[min_node.node_data.name] = min_node
        excluded_nodes.delete(min_node.node_data.name)


    end

    puts "MST IS : "
    mst_edges = []
    included_edges.each do |edge|
      mst_edge = MstEdge.new(edge.node1.node_data.name.to_s, edge.node2.node_data.name.to_s, edge.weight)
      mst_edges << mst_edge
    end

    return mst_edges

  end

  # find the minimum edge from the min_node (from excluded to group) to those nodes already included
  # recompute keys and parents for nodes as applicable
  def find_min_edge(min_node, min_heap, excluded_nodes)

    min_edge_weight = INT_MAX
    min_edge_index = nil

    # loop through all of min_node's neighbor nodes
    # get the node that is in the included_nodes that has smallest edge weight
    # min edge is edge between this min node and its parent

    min_node.neighbors.each_with_index do |neighbor, index|

      # reconstruct the key and parent for adjacent nodes that are not already included
      if min_node.edges[index].weight < neighbor.key

        neighbor.parent = min_node.node_data.name
        neighbor.key = min_node.edges[index].weight

        min_heap.delete_element(neighbor)
        min_heap << neighbor
      end

      # if the neighbor node is not excluded (meaning it is in the set)
      if min_node.edges[index].weight < min_edge_weight && !excluded_nodes.has_key?(neighbor.node_data.name)
        min_edge_weight = min_node.edges[index].weight
        min_edge_index = index
      end

    end

    min_edge = min_node.edges[min_edge_index] unless min_edge_index.nil?


    return min_edge

  end


  def print_graph
    puts "printing graph"
    @node_list.values.each do |node|
      puts "Node (" + node.node_data.name.to_s + ")"

      puts "node's neighbors: "
      node.neighbors.each_with_index do |neighbor, index|
        puts neighbor.node_data.name + " edge " + index.to_s + " " + neighbor.edges[index].to_s
      end
      #node.edges.each do |edge|
      #  puts edge.to_s
      #end

    end
  end





end