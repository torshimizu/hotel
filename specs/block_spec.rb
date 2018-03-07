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

  end

end
