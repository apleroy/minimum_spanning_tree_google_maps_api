class PrimMinimumSpanningTree

  INT_MAX = Float::INFINITY

  def initialize(graph)
    @graph = graph
    @included_nodes = Hash.new
    @included_edges = []
    @excluded_nodes = Hash.new
    @min_heap = MinHeap.new
  end

  def minimum_spanning_tree

    @graph.update_all_nodes_to_distance(INT_MAX)

    # setup the heap of nodes and the excluded sets
    # time complexity is O(n) -> http://stackoverflow.com/questions/9755721/how-can-building-a-heap-be-on-time-complexity
    @graph.node_list.values.each_with_index do |node, index|
      if index == 0
        node.key = 0 # set the first input (random) to be key of 0 (rather than INT_MAX default)
      end
      @excluded_nodes[node.node_data] = node
      @min_heap << node # add node to min_heap (comparable is on key)
    end

    # while there are nodes that exist in the excluded set
    # O(n)
    while @excluded_nodes.count > 0

      # find the node that has the minimum key
      min_node = @min_heap.extract_min # (log(n)) -> total becomes n(log(n))

      # find the minimum edge from this min node to the included set of nodes
      # time complexity of O(E) - where E is the edges from a node
      # total times is 2E (undirected graph - all edges) + 2E * log(n)
      min_edge = find_min_edge(min_node, @min_heap, @included_nodes)

      @included_edges << min_edge unless min_edge.nil?
      @included_nodes[min_node.node_data] = min_node
      @excluded_nodes.delete(min_node.node_data)

    end

    # check to ensure accuracy
    if @included_edges.count == (@graph.node_list.count - 1)
      return @included_edges
    else
      return nil
    end


  end

  private


    # find the minimum edge from the min_node (from excluded to group) to those nodes already included
    # recompute keys and parents for nodes as applicable
    def find_min_edge(min_node, min_heap, included_nodes)
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
          if min_heap.contains_element(neighbor)
            min_heap.delete_element(neighbor)
            min_heap << neighbor
          end
        end

        # if the neighbor node is not excluded (meaning it is in the set)
        if min_node.edges[index].weight < min_edge_weight && included_nodes.has_key?(neighbor.node_data)
          min_edge_weight = min_node.edges[index].weight
          min_edge_index = index
        end

      end

      min_edge = min_node.edges[min_edge_index] unless min_edge_index.nil?

      return min_edge

    end

end