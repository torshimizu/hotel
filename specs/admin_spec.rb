require_relative 'spec_helper'

describe "Hotel::Admin" do

  describe "Admin#initalize" do

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

  describe "Admin#new_reservation" do

    before do
      number_of_rooms = 20
      @admin = Hotel::Admin.new(number_of_rooms)
      @input = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
    end

    let (:new_booking) {
      {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper", room_id: 1}
    }
    let (:block_details) {
      {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
    }

    it "should create a new instance of reservation if the reservation is available" do
      new_reservation = @admin.new_reservation(@input)
      new_reservation.must_be_instance_of Hotel::Reservation
    end

    it "should not be able to reserve a room in a block, if not associated with the block" do
      @admin.reserve_block(block_details) # rooms 1-4 reserved

      proc{@admin.new_reservation(new_booking)}.must_raise NoAvailableRoom

    end

    it "should be able to reserve a room in a block if associated with a block" do
      @admin.reserve_block(block_details) # rooms 1-4

      reservation_details = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper", room_id: 1, block_last_name: "Lovelace"}
      new_reservation = @admin.new_reservation(reservation_details)
      room1 = @admin.rooms.find {|room| room.room_id == new_booking[:room_id]}

      @admin.reservations.must_include new_reservation
      room1.reservations.must_include new_reservation

    end

    it "should raise an error if there are no available rooms for that date" do
      20.times do
        @admin.new_reservation(@input)
      end
      proc{@admin.new_reservation(@input)}.must_raise NoAvailableRoom
    end

    it "should add the reservation to the room's list of reservations" do
      new_reservation = @admin.new_reservation(@input)
      booked_room = new_reservation.room
      booked_room.reservations.must_include new_reservation
    end

  end

  describe "Admin#list_reservations" do

    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
      @input2 = {start_date: "2018-03-07", end_date: "2018-03-09", guest_last_name: "Hopper"}
      @input3 = {start_date: "2018-04-05", end_date: "2018-04-09", guest_last_name: "Hopper"}
      @reservation1 = @admin.new_reservation(@input1)
      @reservation2 = @admin.new_reservation(@input2)
      @reservation3 = @admin.new_reservation(@input3)
    end

    it "should return a collection" do
      my_reservations = @admin.list_reservations("2018-03-07")
      my_reservations.must_be_instance_of Array
    end

    it "should return a collection whose items are an instance of Reservation" do
      my_reservations = @admin.list_reservations("2018-03-07")
      my_reservations.each do |reservation|
        reservation.must_be_instance_of Hotel::Reservation
      end
    end

    it "should only return reservations that are booked during that date" do
      my_reservations = @admin.list_reservations("2018-03-07")
      my_reservations.first.room_id.must_equal @reservation1.room_id
      my_reservations.last.room_id.must_equal @reservation2.room_id
      my_reservations.wont_include @reservation3
    end

    it "should return nil if no reservations for that date" do
      @admin.list_reservations("2018-03-12").must_be_nil
    end
  end

  describe "Admin#calculate_reservation_cost" do

    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
      @reservation1 = @admin.new_reservation(@input1)
    end

    it "should calculate the cost for a given reservation" do
      cost = @admin.calculate_reservation_cost(room_id: @reservation1.room_id, start_date: "2018-03-05")
      cost.must_be_instance_of Float
      cost.must_equal 600.00
    end

    it "should return an error if no reservation" do
      proc{@admin.calculate_reservation_cost(room_id: 7, start_date: "2018-03-05")}.must_raise NoReservation
    end
  end

  describe "Admin#find_available_rooms" do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
      @rooms_to_reserve = 5
      @rooms_to_reserve.times do
        @admin.new_reservation(@input1)
      end
    end

    it "must return a list of rooms that are available for booking during the dates specified" do
      available_rooms = @admin.find_available_rooms("2018-03-05", "2018-03-08")
      available_rooms.must_be_instance_of Array
      available_rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
      available_rooms.length.must_equal @admin.rooms.length - @rooms_to_reserve
    end

    it "must raise an error if there are no available rooms" do
      rooms_to_reserve = (@number_of_rooms - @rooms_to_reserve)
      rooms_to_reserve.times do
        @admin.new_reservation(@input1)
      end
      proc {@admin.new_reservation(@input1)}.must_raise NoAvailableRoom
    end
  end

  describe "Admin#reserve_block" do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
      @rooms_to_reserve = 5
      @rooms_to_reserve.times do
        @admin.new_reservation(@input1)
      end
    end

    it "should create a new instance of Hotel::Block" do
      input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
      new_block = @admin.reserve_block(input)
      new_block.must_be_instance_of Hotel::Block
    end

    it "should raise an error if there are not enough rooms for the block" do
      rooms_to_reserve = 12
      rooms_to_reserve.times do
        @admin.new_reservation(@input1)
      end

      input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
      proc {@admin.reserve_block(input)}.must_raise NoAvailableRoom
    end

    it "should add the block to a room's list of blocks" do
      input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
      new_block = @admin.reserve_block(input)
      new_block.block_rooms.each do |room|
        room.blocks.must_include new_block
      end
    end
  end

  describe "Admin#block" do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
      @new_block = @admin.reserve_block(@input)
    end

    it "should have a collection of Blocks" do
      @admin.blocks.must_be_instance_of Array
      @admin.blocks.each do |block|
        block.must_be_instance_of Hotel::Block
      end
    end
  end

  describe "Admin#get_available_blockrooms" do
    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
      @new_block = @admin.reserve_block(@input)

      let (:reserv_input) {
        {start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace", guest_last_name: "Hopper"}
      }

      let (:block_info) {
        { block_last_name: "Lovelace", start_date: "2018-03-05" }
      }
    end

    it "should return a collection of rooms of a block that are still available" do
      @admin.new_reservation(reserv_input)
      available_blockrooms = @admin.get_available_blockrooms(block_info)

      available_blockrooms.must_be_instance_of Array
      available_blockrooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end

    end
  end
end
