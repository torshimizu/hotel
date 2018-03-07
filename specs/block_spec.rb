require_relative 'spec_helper'

describe 'Hotel::Block'do

  describe 'Block#initialize'do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      block_rooms = @admin.rooms.select {|room| (1..5).include?(room.room_id)}
      input = {start_date: "2018-03-08", end_date: "2018-03-12", block_rooms: block_rooms, rate: 150}
      @new_block = Hotel::Block.new(input)
    end

    it "can be instantiated" do
      @new_block.must_be_instance_of Hotel::Block
    end

    it "has a list of rooms in the block" do
      @new_block.block_rooms.must_be_instance_of Array
      @new_block.block_rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it "cannot have more than 5 rooms in the block" do
      block_rooms = @admin.rooms.select {|room| (1..6).include?(room.room_id)}
      input = {start_date: "2018-03-08", end_date: "2018-03-12", block_rooms: block_rooms, rate: 150}

      proc {Hotel::Block.new(input)}.must_raise StandardError

    end
  end
end
