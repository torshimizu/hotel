require_relative 'notavailable'
require 'date'

module Hotel
  class Admin
    attr_reader :rooms, :reservations, :blocks

    def initialize(num_of_rooms=20) # so that a new Admin can be instantiated for a different hotel with a diff number of rooms
      @rooms = get_rooms(num_of_rooms)
      @reservations = []
      @blocks = []
    end

    def new_reservation(input)
      start_date = DateHelper.parse(input[:start_date])
      end_date = DateHelper.parse(input[:end_date])
      block_last_name = input[:block_last_name]
      room_id = input[:room_id]


      available_room = find_available_rooms(start_date, end_date, block_last_name: block_last_name).first

      if block_last_name
        input[:cost] = find_block(start_date, block_last_name).cost
      end

      specified_room_check(start_date, room_id)

      new_details = {room_id: available_room.room_id, room: available_room}.merge(input) # this should let you specify a room and room_id
      new_reservation = Reservation.new(new_details)

      @reservations << new_reservation
      available_room.add_reservation(new_reservation)

      return new_reservation
    end

    def list_reservations(start_date) # should I change this?
      start_date = DateHelper.parse(start_date)

      date_reservations = @reservations.select do |reservation|
        (reservation.start_date..reservation.end_date).include?(start_date)
      end
      return date_reservations.empty? ? nil : date_reservations
    end

    def calculate_reservation_cost(start_date:, room_id:)
      reservation = check_for_reservation(find_reservation(start_date: start_date, room_id: room_id))
      # return reservation.calculate_cost
      duration = (reservation.end_date - reservation.start_date).to_i
      return (duration * reservation.cost).to_f.round(2)
    end

    def find_reservation(start_date:, room_id:)
      start_date = DateHelper.parse(start_date)
      found_reservation = @reservations.find(nil) do |reservation|
        reservation.start_date == start_date && reservation.room_id == room_id
      end
      return found_reservation
    end

    def find_available_rooms(start_date, end_date, block_last_name: nil)
        available_rooms = @rooms.select { |room| room.check_availability(start_date, end_date, block_last_name: block_last_name) == :AVAILABLE }

      if available_rooms.empty?
        raise NoAvailableRoom.new("No rooms are available for those dates")
      end

      return available_rooms
    end

    def reserve_block(input)
      start_date = input[:start_date]
      end_date = input[:end_date]
      room_count = input[:room_count]

      available_rooms = find_available_rooms(start_date, end_date)

      if available_rooms.length < room_count
        raise NoAvailableRoom.new("Not enough rooms for this block, only #{available_rooms.length} rooms available.")
      end

      rooms_to_block = available_rooms.first(room_count)
      block_details = input.merge( { block_rooms: rooms_to_block })
      new_block = Block.new(block_details)
      @blocks << new_block
      new_block.block_rooms.each do |room|
        room.add_block(new_block)
      end

      return new_block
    end

    def get_available_blockrooms(input)
      start_date = DateHelper.parse(input[:start_date])
      end_date = DateHelper.parse(input[:end_date])
      block_last_name = input[:block_last_name]

      sought_block = find_block(start_date, block_last_name)

      if sought_block.nil?
        raise NoReservation.new("This is not a reserved block")
      end

      available_rooms = sought_block.block_rooms.select do |room|
        room.check_availability(start_date, end_date, block_last_name: block_last_name) == :AVAILABLE
      end
      return available_rooms.empty? ? nil : available_rooms
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

    def specified_room_check(start_date, room_id)
      if room_id
        checking_reservation = find_reservation(start_date: start_date, room_id: room_id)
        raise NoAvailableRoom.new("This room is already reserved.") unless checking_reservation.nil?
      end
    end

    def check_for_reservation(reservation)
      if reservation.nil?
        raise NoReservation.new("There is no reservation for that date")
      end
      return reservation
    end

    def find_block(start_date, block_last_name)
      found_block = @blocks.find do |block|
        block.start_date == start_date && block.block_last_name == block_last_name
      end
      return found_block
    end

  end
end
