require 'rails_helper'

RSpec.describe Place, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "validates the input is not null" do
    place = Place.new(name: "andy")
    expect(place).to be_valid
  end
end
