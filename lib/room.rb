module Hotel
  STANDARD_RATE = 200

  class Room
    attr_reader :room_id, :cost, :reservations

    def initialize(input) # taking a hash so that an array of reservations can be loaded if that's what user wants to do
      @room_id = input[:id]
      # @current_status ||= :AVAILABLE
      @cost = STANDARD_RATE
      @reservations = input[:reservations] == nil ? [] : input[:reservations] # setting the default to an empty array if no reservations for that room
    end

    def check_availability(start_date, end_date) # should this be a date or string instance? should this go here?!?
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
  end
end
