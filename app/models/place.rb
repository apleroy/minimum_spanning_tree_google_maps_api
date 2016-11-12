class Place < ActiveRecord::Base


  belongs_to :minimum_spanning_tree

  def set_key(key)
    @key = key
  end

  def get_key
    @key
  end


end
