class Graph

  INT_MAX = Float::INFINITY
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
    edge = Edge.new(node_from, node_to, weight)
    @edges[edge.hash_key] = weight

    @node_list[node_from.node_data].add_neighbor(node_to)
    @node_list[node_from.node_data].add_edge(edge)

    @node_list[node_to.node_data].add_neighbor(node_from)
    @node_list[node_to.node_data].add_edge(edge)
  end

  def add_directed_edge(node_from, node_to, weight)
    edge = Edge.new(node_from, node_to, weight)
    @edges[edge.hash_key] = weight

    @node_list[node_from.node_data].add_neighbor(node_to)
    @node_list[node_from.node_data].add_edge(edge)
  end

  # --------------

  def prim_mst
    included_nodes = Hash.new
    included_edges = []
    excluded_nodes = Hash.new
    min_heap = MinHeap.new

    # setup the heap of nodes and the excluded sets
    # time complexity is O(n) -> http://stackoverflow.com/questions/9755721/how-can-building-a-heap-be-on-time-complexity
    @node_list.values.each_with_index do |node, index|
      if index == 0
        node.key = 0 # set the first input (random) to be key of 0 (rather than INT_MAX default)
      end
      excluded_nodes[node.node_data] = node
      min_heap << node # add node to min_heap (comparable is on key)
    end

    # while there are nodes that exist in the excluded set
    # O(n)
    while excluded_nodes.count > 0

        # find the node that has the minimum key
        min_node = min_heap.extract_min # (log(n)) -> total become n(log(n))

        # find the minimum edge from this min node to the included set of nodes
        # time complexity of O(E) - where E is the edges from a node
        # total times is 2E (undirected graph - all edges) + 2E * log(n)
        min_edge = find_min_edge(min_node, min_heap, excluded_nodes)

        included_edges << min_edge unless min_edge.nil?
        included_nodes[min_node.node_data] = min_node
        excluded_nodes.delete(min_node.node_data)

    end

    return included_edges

  end

  # find the minimum edge from the min_node (from excluded to group) to those nodes already included
  # recompute keys and parents for nodes as applicable
  def find_min_edge(min_node, min_heap, excluded_nodes)
    min_edge_weight = INT_MAX
    min_edge_index = nil

    # loop through all of min_node's neighbor nodes
    # get the node that is in the included_nodes that has smallest edge weight
    # min edge is edge between this min node and its parent
    # we could get this from the graph edges by using the key of min node and parent

    min_node.neighbors.each_with_index do |neighbor, index|

      # reconstruct the key and parent for adjacent nodes that are not already included
      if min_node.edges[index].weight < neighbor.key

        neighbor.parent = min_node.node_data
        neighbor.key = min_node.edges[index].weight

        # O(log(n))
        min_heap.delete_element(neighbor)
        min_heap << neighbor
      end

      # if the neighbor node is not excluded (meaning it is in the set)
      if min_node.edges[index].weight < min_edge_weight && !excluded_nodes.has_key?(neighbor.node_data)
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
    end
  end


end