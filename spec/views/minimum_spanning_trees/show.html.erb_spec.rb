require 'rails_helper'

RSpec.describe "minimum_spanning_trees/show", type: :view do
  before(:each) do
    @minimum_spanning_tree = assign(:minimum_spanning_tree, MinimumSpanningTree.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    # render
    # expect(rendered).to match(/Name/)
  end
end
