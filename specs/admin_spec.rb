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
      {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
    }
    let (:block_details) {
      {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
    }

    it "should create a new instance of reservation if the reservation is available" do
      new_reservation = @admin.new_reservation(@input)
      new_reservation.must_be_instance_of Hotel::Reservation
    end

    it "should not be able to reserve a room in a block, if not associated with the block" do
      4.times do
        @admin.reserve_block(block_details) # rooms 1-16 reserved
      end
      all_blocked_rooms = @admin.blocks.map {|block| block.block_rooms}.flatten
      all_block_ids = all_blocked_rooms.map {|room| room.room_id}
      new_reservation = @admin.new_reservation(new_booking)
      new_res_id = new_reservation.room_id
      new_res_id.must_equal 17
      all_block_ids.wont_include new_res_id

    end

    it "should be able to reserve a room in a block if associated with a block" do
      @admin.reserve_block(block_details) # rooms 1-4

      reservation_details = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper", room_id: 1, block_last_name: "Lovelace"}
      new_reservation = @admin.new_reservation(reservation_details)
      room1 = @admin.rooms.find {|room| room.room_id == reservation_details[:room_id]}

      @admin.reservations.must_include new_reservation
      room1.reservations.must_include new_reservation

    end

    it "should be able to reserve a room that has another reservation ending on the start date" do
      first_reservation = @admin.new_reservation(@input) # room 1

      new_reservation = {start_date: "2018-03-08", end_date: "2018-03-10", guest_last_name: "Franklin", room_id: 1}
      reservation = @admin.new_reservation(new_reservation)
      reservation.room_id.must_equal first_reservation.room_id
      room1 = @admin.rooms.find {|room| room.room_id == 1}
      room1.reservations.must_include first_reservation
      room1.reservations.must_include reservation
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

    it "should calculate the cost based on the block pricing, if block pricing is specified" do
      block_input = {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace", cost: 150}
      @admin.reserve_block(block_input)

      reservation_deets = {start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace", guest_last_name: "Franklin"}
      new_reservation = @admin.new_reservation(reservation_deets)
      room_id = new_reservation.room_id

      cost = @admin.calculate_reservation_cost(room_id: room_id, start_date: reservation_deets[:start_date])
      cost.must_be_instance_of Float
      cost.must_equal 450.00
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

    let (:block_input) {
      {room_count: 4, start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace"}
    }

    it "should create a new instance of Hotel::Block" do
      new_block = @admin.reserve_block(block_input)
      new_block.must_be_instance_of Hotel::Block
    end

    it "should raise an error if there are not enough rooms for the block" do
      rooms_to_reserve = 12
      rooms_to_reserve.times do
        @admin.new_reservation(@input1)
      end

      proc {@admin.reserve_block(block_input)}.must_raise NoAvailableRoom
    end

    it "should add the block to a room's list of blocks" do
      new_block = @admin.reserve_block(block_input)
      new_block.block_rooms.each do |room|
        room.blocks.must_include new_block
      end
    end

    it "should not block the same rooms for a new block" do
      block1 = @admin.reserve_block(block_input) # rooms 6 - 9
      block1_rmids = block1.block_rooms.map {|room| room.room_id}

      new_block_deets = {room_count: 4, start_date: "2018-03-07", end_date: "2018-03-12", block_last_name: "Franklin", cost: 150}
      new_block = @admin.reserve_block(new_block_deets)
      new_block_rmids = new_block.block_rooms.map {|room| room.room_id}

      overlap = block1_rmids & new_block_rmids
      overlap.must_equal []
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
    end

    let (:reserv_input) {
      {start_date: "2018-03-05", end_date: "2018-03-08", block_last_name: "Lovelace", guest_last_name: "Hopper"}
    }

    let (:block_info) {
      { block_last_name: "Lovelace", start_date: "2018-03-05", end_date: "2018-03-08" }
    }

    it "should return a collection of rooms of a block that are still available" do

      new_reservation = @admin.new_reservation(reserv_input)
      reserved_room_id = new_reservation.room_id

      available_blockrooms = @admin.get_available_blockrooms(block_info)

      available_blockrooms.must_be_instance_of Array
      available_blockrooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end

      available_blockrooms_ids = available_blockrooms.map { |room| room.room_id }
      available_blockrooms_ids.wont_include reserved_room_id
    end

    it "should return nil if there are no available rooms in the block" do
      @input[:room_count].times do
        @admin.new_reservation(reserv_input)
      end
      available_blockrooms = @admin.get_available_blockrooms(block_info)

      available_blockrooms.must_be_nil
    end

    it "should raise an error if that is not a reserved block" do
      not_a_block = { block_last_name: "Lovelace", start_date: "2018-03-06", end_date: "2018-03-08" }
      proc{@admin.get_available_blockrooms(not_a_block)}.must_raise NoReservation
    end
  end
end
