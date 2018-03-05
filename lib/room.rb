module Hotel
  STANDARD_RATE = 200

  class Room
    attr_reader :room_id, :cost

    def initialize(input)
      @room_id = input[:id]
      # @current_status ||= :AVAILABLE
      @cost = STANDARD_RATE
      @reservations = input[:reservations] == nil ? [] : input[:reservations] # setting the default to an empty array if no reservations for that room
    end

    def check_status(start_date, end_date)
    end
  end
end
