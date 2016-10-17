require 'rails_helper'

RSpec.describe "MinimumSpanningTrees", type: :request do
  describe "GET /minimum_spanning_trees" do
    it "works! (now write some real specs)" do
      get minimum_spanning_trees_path
      expect(response).to have_http_status(200)
    end
  end
end
