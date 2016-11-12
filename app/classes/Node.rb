class Node

  INT_MAX = 999999999999

  include Comparable

  attr_accessor :node_data, :neighbors, :edges, :key, :parent

  def initialize(node_data)
    @node_data = node_data # object, name, or identifier of node (a place object)
    @neighbors = [] # this node's neighbor nodes - other place objects
    @edges = [] #this node neighbor edges - edge objects connecting place object to place object

    @key = INT_MAX
    @parent = nil
  end

  def add_neighbor(node)
    @neighbors << node # add the actual node to the neighbor list
  end

  def add_edge(edge)
    @edges << edge # add the edge (all edges will be from this node to another node)
  end


  def <=>(other)
    @key <=> other.key
  end


end