class Node

  INT_MAX = Float::INFINITY

  include Comparable

  attr_accessor :node_data, :neighbors, :edges, :key, :parent

  def initialize(params = {})
    @node_data = params.fetch(:node_data, nil) # object, name, or identifier of node (a place object)
    @neighbors = params.fetch(:neighbors, []) # this node's neighbor nodes - other place objects
    @edges = params.fetch(:edges, []) # this node neighbor edges - edge objects connecting place object to place object
    @key = params.fetch(:key, INT_MAX)
    @parent = params.fetch(:parent, nil)
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