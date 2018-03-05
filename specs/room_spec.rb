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

    it "should be able to return a list of its reservations" do
      @new_room.reservations.must_be_kind_of Array
      @new_room.reservations.each do |reservation|
        reservation.must_be_instance_of Hotel::Reservation
      end
    end
  end

  describe "Room#check_availability" do
    before do
      details = {start_date: "2018-03-03", end_date: "2018-03-08", room_id: 1, guest_last_name: "Hopper"}
      new_reservation = Hotel::Reservation.new(details)
      @new_room = Hotel::Room.new({id: 1, reservations: [new_reservation]})
    end

    it "should return UNAVAILABLE if a reservation is wanted during a booked date" do
      start_date1 = Date.parse("2018-03-05")
      end_date1 = Date.parse("2018-03-09")
      status = @new_room.check_availability(start_date1, end_date1)
      status.must_equal :UNAVAILABLE

      start_date2 = Date.parse("2018-03-01")
      end_date2 = Date.parse("2018-03-07")
      status = @new_room.check_availability(start_date2, end_date2)
      status.must_equal :UNAVAILABLE
    end

    it "should return AVAILABLE if a room is available during that time" do
      start_date = Date.parse("2018-03-09")
      end_date = Date.parse("2018-03-12")
      status = @new_room.check_availability(start_date, end_date)
      status.must_equal :AVAILABLE
    end
  end
end
