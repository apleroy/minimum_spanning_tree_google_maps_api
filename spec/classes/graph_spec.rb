require 'rails_helper'

RSpec.describe Graph, type: :class do


  describe "initialization tests" do

    it "initializes with a null element at the first position" do
      min_heap = MinHeap.new
      expect(min_heap.count).to eq(1)
    end

  end

end
