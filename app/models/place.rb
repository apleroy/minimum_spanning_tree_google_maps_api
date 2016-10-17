class Place < ActiveRecord::Base

  #include Node

  belongs_to :minimum_spanning_tree
end
