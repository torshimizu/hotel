require_relative 'spec_helper'

describe "Hotel::Admin" do
  describe "initalize" do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
    end
    it "should have a collection of 20 rooms" do
      @admin.must_respond_to :rooms
      @admin.rooms.must_be_instance_of Array
      @admin.rooms.length.must_equal @number_of_rooms
      @admin.rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it "should have a collection of reservations" do
      @admin.must_respond_to :reservations
      @admin.reservations.must_be_instance_of Array
    end


  end
end
