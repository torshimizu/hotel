require_relative 'spec_helper'

describe "Hotel::Reservation" do
  describe "initialize" do
    before do
      @room = Hotel::Room.new({room_id: 2})
      details = { start_date: "2018-03-23", end_date: "2018-03-25", room: @room, guest_last_name: "Lovelace" }
      @reservation = Hotel::Reservation.new(details)
    end

    it "must be an instance of Reservation" do
      @reservation.must_be_instance_of Hotel::Reservation
    end

    it "must raise an error if given an invalid start or end date" do
      details = { start_date: "2018-03-23", end_date: "2018-02-25", room_id: 2 }
      proc {Hotel::Reservation.new(details)}.must_raise StandardError

      details2 = { room_id: 2 }
      proc {Hotel::Reservation.new(details2)}.must_raise StandardError
    end

    it "must have an instance of room" do
      @reservation.must_respond_to :room
      @reservation.room.must_be_instance_of Hotel::Room
      @reservation.room_id.must_equal @room.room_id
    end

    it "must have a guest" do
      @reservation.must_respond_to :guest_last_name
      @reservation.guest_last_name.must_equal "Lovelace"
    end
  end

  describe "Reservation#calculate_cost" do
    before do
      details = { start_date: "2018-03-23", end_date: "2018-03-25", room_id: 2, guest_last_name: "Lovelace" }
      @reservation = Hotel::Reservation.new(details)
    end

    it "must return the cost of the reservation" do
      @reservation.calculate_cost.must_be_instance_of Float
      @reservation.calculate_cost.must_equal 400.00
    end

  end

end
