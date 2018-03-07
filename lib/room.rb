module Hotel
  STANDARD_RATE = 200

  class Room
    attr_reader :room_id, :cost, :reservations, :blocks

    def initialize(input) # taking a hash so that an array of reservations can be loaded if that's what user wants to do
      @room_id = input[:id]
      @cost = STANDARD_RATE
      @reservations = input[:reservations] == nil ? [] : input[:reservations] # setting the default to an empty array if no reservations for that room
      @blocks = input[:block_rooms] == nil ? [] : input[:block_rooms]
    end

    def check_availability(start_date, end_date) # should this be a date or string instance?
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)

      @reservations.each do |reservation|
        range = (reservation.start_date..reservation.end_date)
        if range.include?(start_date) || range.include?(end_date)
          return :UNAVAILABLE
        end
      end
      return :AVAILABLE
    end

    def add_reservation(reservation)
      @reservations << reservation
    end

    def add_block(block)
      @blocks << block
    end
  end
end
