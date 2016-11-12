require 'rails_helper'

RSpec.describe MinHeap, type: :class do

  it "validates the input is not null" do
    min_heap = MinHeap.new
    expect(min_heap).to be_valid
  end

end