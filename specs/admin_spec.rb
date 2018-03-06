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
      @number_of_rooms = 20
      @admin = Hotel::Admin.new(@number_of_rooms)
      input = {start_date: "03-05-2018", end_date: "03-08-2018", room_id: 3}
      @new_reservation = @admin.new_reservation(input)
    end

    it "should create a new instance of reservation if the reservation is available" do
      new_reservation.must_be_instance_of Hotel::Reservation
    end

    it "should return UNAVAILABLE if the room is booked during the requested time" do
      reservation2 = {start_date: "2018-03-07", end_date: "2018-03-09", room_id: 3}
      proc {@admin.new_reservation(reservation2)}.must_raise NotAvailableRoom

    end

  end
end
