json.array!(@minimum_spanning_trees) do |minimum_spanning_tree|
  json.extract! minimum_spanning_tree, :id, :name
  json.url minimum_spanning_tree_url(minimum_spanning_tree, format: :json)
end
