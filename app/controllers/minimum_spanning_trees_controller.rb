class MinimumSpanningTreesController < ApplicationController
  before_action :set_minimum_spanning_tree, only: [:show, :edit, :update, :destroy]

  require 'rest-client'
  require 'json'

  # GET /minimum_spanning_trees
  # GET /minimum_spanning_trees.json
  def index
    @minimum_spanning_trees = MinimumSpanningTree.all
  end

  # GET /minimum_spanning_trees/1
  # GET /minimum_spanning_trees/1.json
  def show
    graph = @minimum_spanning_tree.graph
    graph.print_graph
    @mst_edges = graph.minimum_spanning_tree
    #@response = JSON.parse(RestClient.get(@minimum_spanning_tree.api_call))

    url = "https://maps.googleapis.com/maps/api/js?key="
    callbackMethod = "initMap"
    key = ENV['GOOGLE_MAPS']
    @endpoint = url + key + "&libraries=places&callback=" + callbackMethod

    @andy = "andy alert";
  end

  # GET /minimum_spanning_trees/new
  def new
    @minimum_spanning_tree = MinimumSpanningTree.new
    url = "https://maps.googleapis.com/maps/api/js?key="
    callbackMethod = "initMap"
    key = ENV['GOOGLE_MAPS']
    @endpoint = url + key + "&libraries=places&callback=" + callbackMethod
  end

  # GET /minimum_spanning_trees/1/edit
  def edit
  end

  # POST /minimum_spanning_trees
  # POST /minimum_spanning_trees.json
  def create
    @minimum_spanning_tree = MinimumSpanningTree.create(minimum_spanning_tree_params)
    place_names = minimum_spanning_tree_params[:place_names]

    unless place_names.nil?
      place_names.each do |place_name|
        @minimum_spanning_tree.places.create(name: place_name)
      end
    end

    respond_to do |format|
      # if @minimum_spanning_tree.save
         format.html { redirect_to @minimum_spanning_tree, notice: 'Minimum spanning tree was successfully created.' }
      #   format.json { render :show, status: :created, location: @minimum_spanning_tree }
      # else
      #   format.html { render :new }
      #   format.json { render json: @minimum_spanning_tree.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /minimum_spanning_trees/1
  # PATCH/PUT /minimum_spanning_trees/1.json
  def update
    @minimum_spanning_tree.update(minimum_spanning_tree_params)

    place_names = minimum_spanning_tree_params[:place_names]
    minimum_spanning_tree_places = @minimum_spanning_tree.places
    current_places_hash = minimum_spanning_tree_places.map { |p| [p.name, p] }.to_h

    unless place_names.nil?
      place_names.each do |place_name|
        if current_places_hash.key?(place_name)
          #update and remove from hash
          current_places_hash[place_name].update(name: place_name)
          current_places_hash.delete(place_name)
        else #current_places_hash.key?(place_name)
          minimum_spanning_tree_places.create(name: place_name)
        end
      end
    end

    #delete all remaining objects in the hash
    current_places_hash.each do |key, value|
      value.destroy
    end

    respond_to do |format|
      # if @minimum_spanning_tree.update(minimum_spanning_tree_params)
         format.html { redirect_to @minimum_spanning_tree, notice: 'Minimum spanning tree was successfully updated.' }
      #   format.json { render :show, status: :ok, location: @minimum_spanning_tree }
      # else
         #format.html { render :edit }
      #   format.json { render json: @minimum_spanning_tree.errors, status: :unprocessable_entity }
      # end
    end
  end

  # DELETE /minimum_spanning_trees/1
  # DELETE /minimum_spanning_trees/1.json
  def destroy
    @minimum_spanning_tree.destroy
    respond_to do |format|
      format.html { redirect_to minimum_spanning_trees_url, notice: 'Minimum spanning tree was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_minimum_spanning_tree
      @minimum_spanning_tree = MinimumSpanningTree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def minimum_spanning_tree_params
      params.require(:minimum_spanning_tree).permit(:name, :place_names => [])
    end
end
