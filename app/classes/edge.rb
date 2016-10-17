class Edge

  attr_accessor :node1, :node2, :weight

  def initialize(node1, node2, weight)
    @node1 = node1
    @node2 = node2
    @weight = weight
  end

  def <=>(other)
    self.weight <=> other.weight
  end

end