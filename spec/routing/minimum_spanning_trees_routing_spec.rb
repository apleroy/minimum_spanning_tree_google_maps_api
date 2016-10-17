require "rails_helper"

RSpec.describe MinimumSpanningTreesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/minimum_spanning_trees").to route_to("minimum_spanning_trees#index")
    end

    it "routes to #new" do
      expect(:get => "/minimum_spanning_trees/new").to route_to("minimum_spanning_trees#new")
    end

    it "routes to #show" do
      expect(:get => "/minimum_spanning_trees/1").to route_to("minimum_spanning_trees#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/minimum_spanning_trees/1/edit").to route_to("minimum_spanning_trees#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/minimum_spanning_trees").to route_to("minimum_spanning_trees#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/minimum_spanning_trees/1").to route_to("minimum_spanning_trees#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/minimum_spanning_trees/1").to route_to("minimum_spanning_trees#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/minimum_spanning_trees/1").to route_to("minimum_spanning_trees#destroy", :id => "1")
    end

  end
end
