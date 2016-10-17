require 'rails_helper'

RSpec.describe "minimum_spanning_trees/edit", type: :view do
  before(:each) do
    @minimum_spanning_tree = assign(:minimum_spanning_tree, MinimumSpanningTree.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit minimum_spanning_tree form" do
    render

    assert_select "form[action=?][method=?]", minimum_spanning_tree_path(@minimum_spanning_tree), "post" do

      assert_select "input#minimum_spanning_tree_name[name=?]", "minimum_spanning_tree[name]"
    end
  end
end
