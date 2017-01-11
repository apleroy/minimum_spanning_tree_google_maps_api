require 'rails_helper'

RSpec.describe Graph, type: :class do

    it 'initializes with a null edge hash and null node hash' do
      graph = Graph.new
      expect(graph.edges.count).to eq(0)
      expect(graph.node_list.count).to eq(0)
    end

    it 'adds node to graph' do
      graph = Graph.new
      expect(graph.edges.count).to eq(0)
      expect(graph.node_list.count).to eq(0)

      graph.add_node(Node.new(node_data: 'test'))
      expect(graph.node_list.count).to eq(1)
    end
    
    it 'finds node by element' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)

      graph.add_node(node1)
      graph.add_node(node2)

      node_found = graph.find_node_by_element(1)
      expect(node_found).to eq(node1)
    end
    
    it 'adds directed edge' do
      graph = Graph.new
      
      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)
      
      graph.add_node(node1)
      graph.add_node(node2)
      
      graph.add_directed_edge(node1, node2, 1)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(0)
    end

    it 'adds undirected edge' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)

      graph.add_node(node1)
      graph.add_node(node2)

      graph.add_undirected_edge(node1, node2, 1)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(1)
    end

    it 'does not add duplicated undirected edge' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)

      graph.add_node(node1)
      graph.add_node(node2)

      graph.add_undirected_edge(node1, node2, 1)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(1)

      graph.add_undirected_edge(node1, node2, 1)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(1)

    end

    it 'does not add new undirected edge between two already connected nodes' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)

      graph.add_node(node1)
      graph.add_node(node2)

      graph.add_undirected_edge(node1, node2, 5)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(1)

      graph.add_undirected_edge(node1, node2, 4)
      expect(graph.edges.count).to eq(1)
      expect(graph.node_list.count).to eq(2)

      expect(node1.edges.count).to eq(1)
      expect(node2.edges.count).to eq(1)

      edge = Edge.new(node1, node2, 1)
      expect(graph.edges[edge.hash_key]).to eq(5)

    end


    it 'finds mst with zero nodes' do
      graph = Graph.new
      expect(graph.minimum_spanning_tree).to eq(nil)
    end

    it 'finds mst with one node' do
      graph = Graph.new
      expect(graph.minimum_spanning_tree).to eq(nil)
    end

    it 'finds mst with two nodes - undirected edge' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)

      graph.add_node(node1)
      graph.add_node(node2)

      graph.add_undirected_edge(node1, node2, 1)

      edge = Edge.new(node1, node2, 1)
      expect(graph.minimum_spanning_tree).to include(edge)
    end

    it 'finds mst with three nodes - undirected edges' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)
      node3 = Node.new(node_data: 3)

      graph.add_node(node1)
      graph.add_node(node2)
      graph.add_node(node3)

      graph.add_undirected_edge(node1, node2, 1)
      graph.add_undirected_edge(node2, node3, 2)

      edge1 = Edge.new(node1, node2, 1)
      edge2 = Edge.new(node2, node3, 2)

      expect(graph.minimum_spanning_tree).to include(edge1)
      expect(graph.minimum_spanning_tree).to include(edge2)
    end

    it 'finds mst with three nodes - unconnected graph' do
      graph = Graph.new

      node1 = Node.new(node_data: 1)
      node2 = Node.new(node_data: 2)
      node3 = Node.new(node_data: 3)

      graph.add_node(node1)
      graph.add_node(node2)
      graph.add_node(node3)

      graph.add_undirected_edge(node1, node2, 1)

      expect(graph.minimum_spanning_tree).to eq(nil)
    end

    it 'finds mst with four nodes - connected graph' do

      # A -6- B
      # |     |
      # 2     3
      # |     |
      # C -1- D
      # mst is A-C, C-D, D-B

      graph = Graph.new

      nodeA = Node.new(node_data: 'A')
      nodeB = Node.new(node_data: 'B')
      nodeC = Node.new(node_data: 'C')
      nodeD = Node.new(node_data: 'D')

      graph.add_node(nodeA)
      graph.add_node(nodeB)
      graph.add_node(nodeC)
      graph.add_node(nodeD)

      graph.add_undirected_edge(nodeA, nodeB, 6)
      graph.add_undirected_edge(nodeA, nodeC, 2)
      graph.add_undirected_edge(nodeC, nodeD, 1)
      graph.add_undirected_edge(nodeB, nodeD, 3)

      edge1 = Edge.new(nodeA, nodeB, 6)
      edge2 = Edge.new(nodeA, nodeC, 2)
      edge3 = Edge.new(nodeC, nodeD, 1)
      edge4 = Edge.new(nodeB, nodeD, 3)

      mst = graph.minimum_spanning_tree

      mst2 = graph.minimum_spanning_tree

      expect(mst).to_not include(edge1)
      expect(mst).to include(edge2, edge3, edge4)

      expect(mst2).to_not include(edge1)
      expect(mst2).to include(edge2, edge3, edge4)


    end

end
