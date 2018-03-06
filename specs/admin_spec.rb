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

  describe "Admin#new_reservation" do

    before do
      number_of_rooms = 20
      @admin = Hotel::Admin.new(number_of_rooms)
      @input = {start_date: "2018-03-05", end_date: "2018-03-08", room_id: 3}
      @room3_reservation_count = @admin.find_room(3).reservations.length
      @new_reservation = @admin.new_reservation(@input)
    end

    it "should create a new instance of reservation if the reservation is available" do
      @new_reservation.must_be_instance_of Hotel::Reservation
    end

    it "should raise an error if the room is booked during the requested time" do
      reservation2 = {start_date: "2018-03-07", end_date: "2018-03-09", room_id: 3}
      proc {@admin.new_reservation(reservation2)}.must_raise NotAvailableRoom
    end

    it "should add the reservation to the room's list of reservations" do
      booked_room = @new_reservation.room
      booked_room.reservations.must_include @new_reservation
      booked_room.reservations.length.must_equal @room3_reservation_count + 1
    end

  end

  describe "Admin#list_reservations" do

    before do
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", room_id: 3}
      @input2 = {start_date: "2018-03-07", end_date: "2018-03-09", room_id: 4}
      @input3 = {start_date: "2018-04-05", end_date: "2018-04-09", room_id: 2}
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
      @input1 = {start_date: "2018-03-05", end_date: "2018-03-08", room_id: 3}
      @reservation1 = @admin.new_reservation(@input1)
    end

    it "should calculate the cost for a given reservation" do
      cost = @admin.calculate_reservation_cost(room_id: 3, start_date: "2018-03-05")
      cost.must_be_instance_of Float
      cost.must_equal 600.00
    end
  end
end
