class MinimumSpanningTree < ActiveRecord::Base

  attr_accessor :place_names
  has_many :places

  validates :name, presence: true

  def graph
    google_maps_api_client = GoogleMatrixApiClient.new
    return google_maps_api_client.build_graph(self.places)
  end


end
