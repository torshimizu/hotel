require_relative 'spec_helper'

describe "Hotel::Room" do
  describe "initialize" do
    it "can be created" do
      new_room = Hotel::Room.new
      new_room.must_be_instance_of Hotel::Room
    end
  end
end
