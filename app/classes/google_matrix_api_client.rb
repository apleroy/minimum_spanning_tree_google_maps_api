class GoogleMatrixApiClient

  require 'rest-client'
  require 'json'

  attr_reader :places

  def initialize(places)
    @places = places
  end

  def build_graph

    graph = Graph.new

    #build graph
    @places.each do |place|
      node = Node.new(node_data: place)
      graph.add_node(node)
    end

    begin
      rest_client_response = RestClient.get(api_call(@places))
      api_response = JSON.parse(rest_client_response)

      @places.each_with_index do |place, index|
        node_from = graph.find_node_by_element(place)
        api_response['rows'][index]['elements'].each_with_index do |element, i|
          status = element['status']
          if status == 'OK'
            node_to = graph.find_node_by_element(@places[i])
            distance = element['distance']['value'].to_i
            if distance > 1 # don't add self to self
              graph.add_undirected_edge(node_from, node_to, distance) #because this is a matrix with repeats - can use directed edge add
            end
          else
            raise RestClient::Exception # example would be invalid city to city direction
          end

        end
      end
    rescue SocketError => socketerror
      puts socketerror
      return socketerror
    rescue RestClient::Exception => restexception
      puts restexception
      return restexception
    rescue Exception => generalexception
      puts generalexception
      return generalexception
    end

    return graph

  end

  private

  def formatted_locations(locations)
    formatted_locations = ""
    locations.each_with_index do |location, index|
      formatted_location = location.name.gsub(/[\,]/ ,"").gsub(/\s/,'+')
      if index != locations.size - 1
        formatted_locations += formatted_location + '|'
      else
        formatted_locations += formatted_location
      end
    end
    return formatted_locations
  end

  def api_call(locations)
    formatted_location_list = formatted_locations(locations)
    key = ENV['GOOGLE_MAPS']
    url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
    api_call = url + 'origins=' + formatted_location_list + '&destinations=' + formatted_location_list + '&mode=walking&units=imperial&language=en-US' + '&key=' + key
    return api_call
  end

end