class MinimumSpanningTreesController < ApplicationController
  before_action :set_minimum_spanning_tree, only: [:show, :edit, :update, :destroy]
  before_filter :set_common_variables

  # GET /minimum_spanning_trees
  # GET /minimum_spanning_trees.json
  def index
    @minimum_spanning_trees = MinimumSpanningTree.all.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /minimum_spanning_trees/1
  # GET /minimum_spanning_trees/1.json
  def show
    graph = @minimum_spanning_tree.graph
    @mst_edges = []
    if !graph.is_a? Exception
      mst = graph.minimum_spanning_tree
      @mst_edges = graph.minimum_spanning_tree_edges(mst)
    else
      flash.now[:error] = 'There was an error calculating your Minimum Spanning Tree.
        Be sure that your locations have valid addresses and all can be reached by driving from place to place.'
    end

  end

  # GET /minimum_spanning_trees/new
  def new
    @minimum_spanning_tree = MinimumSpanningTree.new
  end

  # GET /minimum_spanning_trees/1/edit
  def edit
    graph = @minimum_spanning_tree.graph
    @mst_edges = []

    if !graph.is_a? Exception
      mst = graph.minimum_spanning_tree
      @mst_edges = graph.minimum_spanning_tree_edges(mst)
    end
  end

  # POST /minimum_spanning_trees
  # POST /minimum_spanning_trees.json
  def create
    @minimum_spanning_tree = MinimumSpanningTree.new(minimum_spanning_tree_params)

    respond_to do |format|
      if @minimum_spanning_tree.valid?
        if @minimum_spanning_tree.save
          place_names = minimum_spanning_tree_params[:place_names]
          unless place_names.nil?
            place_names.uniq.each do |place_name|
              @minimum_spanning_tree.places.create(name: place_name)
            end
          end
          format.html { redirect_to @minimum_spanning_tree, flash: { success: 'Minimum spanning tree was successfully created.' } }
          format.json { render :show, status: :created, location: @minimum_spanning_tree }
        end
      else
         format.html { render new_minimum_spanning_tree_path, flash: { error: 'There was an error creating your Minimum spanning tree.' } }
         format.json { render json: @minimum_spanning_tree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /minimum_spanning_trees/1
  # PATCH/PUT /minimum_spanning_trees/1.json
  def update
    @minimum_spanning_tree.update(minimum_spanning_tree_params)

    respond_to do |format|
      if @minimum_spanning_tree.valid?
        new_place_params = minimum_spanning_tree_params[:place_names]
        mst_places = @minimum_spanning_tree.places

        # pass in a list of places, and the current place objects associated with this mst resource
        update_list_from_params(new_place_params, mst_places)

        format.html { redirect_to @minimum_spanning_tree, flash: { success: 'Minimum spanning tree was successfully updated.' } }
      else

        format.html { render :edit }
        format.json { render json: @minimum_spanning_tree.errors, status: :unprocessable_entity }

      end
    end
  end

  # DELETE /minimum_spanning_trees/1
  # DELETE /minimum_spanning_trees/1.json
  def destroy
    @minimum_spanning_tree.destroy
    respond_to do |format|
      format.html { redirect_to minimum_spanning_trees_url, success: 'Minimum spanning tree was successfully destroyed.' }
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

    def set_common_variables
      url = 'https://maps.googleapis.com/maps/api/js?key='
      callback_method = 'initMap'
      key = ENV['GOOGLE_MAPS']
      @endpoint = url + key + '&libraries=places&callback=' + callback_method
    end

    # helper method for the update method
    # accepts a list of place parameters and the current object list
    # updates and makes necessary deletions from a list in O(n)
    def update_list_from_params(new_params, current_object_list)

      # create a hash of all places [k,v] = ['place name', place object]
      current_object_hash = current_object_list.map { |p| [p.name, p] }.to_h

      unless new_params.nil?
        new_params.uniq.each do |param_name|
          if current_object_hash.key?(param_name)
            # update and remove from hash
            current_object_hash[param_name].update(name: param_name)
            current_object_hash.delete(param_name)
          else
            # create the new object
            current_object_list.create(name: param_name)
          end
        end
      end

      #delete all remaining objects in the hash
      current_object_hash.each do |key, value|
        value.destroy
      end
    end
end
