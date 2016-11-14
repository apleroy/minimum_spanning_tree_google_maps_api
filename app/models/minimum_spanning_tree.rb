class MinimumSpanningTree < ActiveRecord::Base
  require 'rest-client'
  require 'json'
  attr_accessor :place_names
  has_many :places

  validates :name, presence: true

  INT_MAX = 9999999

  def graph
    graph = Graph.new

    self.places.each do |place|
      node = Node.new(place)
      graph.add_node(node)
    end

    begin
      rest_client_response = RestClient.get(api_call)
      api_response = JSON.parse(rest_client_response)
      self.places.each_with_index do |place, index|
        node_from = graph.find_node_by_element(place)
        api_response['rows'][index]['elements'].each_with_index do |element, i|
          status = element['status']
          if status == 'OK'
            node_to = graph.find_node_by_element(self.places[i])
            distance = element['distance']['value'].to_i
            if distance > 1 # don't add self to self
              graph.add_directed_edge(node_from, node_to, distance) #because this is a matrix with repeats - can use directed edge add
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


  private

    def api_call
      key = ENV['GOOGLE_MAPS']
      url = 'https://maps.googleapis.com/maps/api/distancematrix/json?'
      api_call = url + 'origins=' + locations + '&destinations=' + locations + '&mode=walking&units=imperial&language=en-US' + '&key=' + key
      return api_call
    end


end
