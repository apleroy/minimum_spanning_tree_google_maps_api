class MinimumSpanningTree < ActiveRecord::Base
  require 'rest-client'
  include HTTParty
  require 'json'
  attr_accessor :place_names
  has_many :places


  def graph
    api_response = JSON.parse(RestClient.get(api_call))
    puts api_response
    graph = Graph.new(self.places)

    self.places.each_with_index do |place, index|
      from = place
      api_response['rows'][index]['elements'].each_with_index do |element, i|
        to = self.places[i]
        if element.nil?
          puts "here"
          return
        else
          distance = element['distance']['value'].to_i / 1760
          if distance > 1
            graph.add_edge(from, to, distance)
          end
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
    key = 'AIzaSyC_mVy34lYzANe1yn2nemmhv-SeVZWltUE'
    url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
    api_call = url + 'origins=' + locations + '&destinations=' + locations + '&mode=walking&units=imperial&language=en-US' + '&key=' + key
    puts api_call
    return api_call
  end


end
