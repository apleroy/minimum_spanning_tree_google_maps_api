require 'rails_helper'

RSpec.describe "minimum_spanning_trees/new", type: :view do
  before(:each) do
    assign(:minimum_spanning_tree, MinimumSpanningTree.new(
      :name => "MyString"
    ))
  end

  it "renders new minimum_spanning_tree form" do
    render

    assert_select "form[action=?][method=?]", minimum_spanning_trees_path, "post" do

      assert_select "input#minimum_spanning_tree_name[name=?]", "minimum_spanning_tree[name]"
    end
  end
end
