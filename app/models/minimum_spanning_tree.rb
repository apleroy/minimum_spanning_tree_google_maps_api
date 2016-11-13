class MinimumSpanningTree < ActiveRecord::Base
  require 'rest-client'
  require 'json'
  attr_accessor :place_names
  has_many :places

  INT_MAX = 9999999

  def graph
    graph = Graph.new
    api_response = JSON.parse(RestClient.get(api_call))

    self.places.each do |place|
      node = Node.new(place)
      graph.add_node(node)
    end

    self.places.each_with_index do |place, index|
      node_from = graph.find_node_by_element(place)

      api_response['rows'][index]['elements'].each_with_index do |element, i|
        node_to = graph.find_node_by_element(self.places[i])

          distance = element['distance']['value'].to_i
          if distance > 1 # don't add self to self
            graph.add_directed_edge(node_from, node_to, distance) #because this is a matrix with repeats - can use directed edge add
          end

      end

    end

    return graph
  end


  def locations
    locations = ""
    self.places.each_with_index do |place, index|
      formatted_place = place.name.gsub(/[\,]/ ,"").gsub(/\s/,'+')
      if index != self.places.size - 1
        locations += formatted_place + '|'
      else
        locations += formatted_place
      end
    end
    return locations
  end


  def api_call
    key = ENV['GOOGLE_MAPS']
    url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
    api_call = url + 'origins=' + locations + '&destinations=' + locations + '&mode=walking&units=imperial&language=en-US' + '&key=' + key
    return api_call
  end


end
