require_relative 'notavailable'
require 'date'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize(num_of_rooms=20) # so that a new Admin can be instantiated for a different hotel with a diff number of rooms
      @rooms = get_rooms(num_of_rooms)
      @reservations = []
    end

    def new_reservation(input) # maybe this new_reservation should look at available dates first then choose an available room
      room = find_room(input[:room_id])
      input.merge!({room: room})
      check_room_status(input[:room], input[:start_date], input[:end_date])
      new_reservation = Reservation.new(input)

      @reservations << new_reservation
      room.add_reservation(new_reservation)

      return new_reservation
    end

    def find_room(id)
      room = @rooms.find { |rm| rm.room_id == id }
      if room.nil?
        raise ArgumentError.new("Not a valid room number")
      end
      return room
    end

    def list_reservations(start_date)
      start_date = Date.parse(start_date)

      target_reservations = @reservations.select do |reservation|
        (reservation.start_date..reservation.end_date).include?(start_date)
      end
      return target_reservations.empty? ? nil : target_reservations
    end

    def calculate_reservation_cost(start_date:, room_id:)
      reservation = find_reservation(start_date: start_date, room_id: room_id)
      reservation.calculate_cost
    end

    def find_reservation(start_date:, room_id:)
      start_date = Date.parse(start_date)
      @reservations.find do |reservation|
        reservation.start_date == start_date && reservation.room_id == room_id
      end
    end

    private

    def get_rooms(num_of_rooms) # factory method
      rooms = []
      num_of_rooms.times do |i|
        input = {id: (i + 1)}
        rooms << Room.new(input)
      end
      return rooms
    end

    def check_room_status(room, start_date, end_date)
      status = room.check_availability(start_date, end_date)
      if status == :UNAVAILABLE
        raise NotAvailableRoom.new("Room #{room.room_id} is not available for those dates")
      end
    end

  end
end
