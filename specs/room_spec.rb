require_relative 'spec_helper'

describe "Hotel::Room" do
  describe "initialize" do
    before do
      @new_room = Hotel::Room.new({id: 1})
    end
    it "can be created" do
      @new_room.must_be_instance_of Hotel::Room
    end

    it "must have a room_id" do
      @new_room.must_respond_to :room_id
      @new_room.room_id.must_equal 1
    end

    it "must be able to return its cost" do
      @new_room.cost.must_be_instance_of Integer
    end
  end
end
