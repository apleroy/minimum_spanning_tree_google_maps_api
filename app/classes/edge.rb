class Edge

  include Comparable

  attr_accessor :node1, :node2, :weight

  def initialize(node1, node2, weight)
    @node1 = node1
    @node2 = node2
    @weight = weight
  end

  def hash_key
    return @node1.node_data.to_s + "->" + @node2.node_data.to_s
  end

  def <=>(other)
    @weight <=> other.weight
  end

end