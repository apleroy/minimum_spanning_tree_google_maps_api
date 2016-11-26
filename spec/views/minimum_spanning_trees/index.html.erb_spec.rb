require 'rails_helper'

RSpec.describe "minimum_spanning_trees/index", type: :view do
  before(:each) do
    assign(:minimum_spanning_trees, [
      MinimumSpanningTree.create!(
        :name => "Name"
      ),
      MinimumSpanningTree.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of minimum_spanning_trees" do
    # render
    # assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
