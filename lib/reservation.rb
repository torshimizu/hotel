require 'date'

module Hotel
  class Reservation
    attr_reader :room_id, :start_date, :end_date, :guest_last_name

    def initialize(input)
      @start_date = Date.parse(input[:start_date])
      @end_date = Date.parse(input[:end_date])
      @room = get_room(input[:room_id]) # might need to consider multiple rooms?
      @guest_last_name = input[:guest_last_name]
      @guest_first_name = input[:guest_first_name].nil? ? nil : input[:guest_first_name]


      if (@start_date == nil || @end_date == nil) || @start_date > @end_date
        raise StandardError.new("Invalid dates")
      end
    end

    def calculate_cost
      duration = (@end_date - @start_date).to_i
      return duration * STANDARD_RATE
    end

    private

    def get_room(id)
      room = Admin.rooms.find(nil) { |rm| rm.id == id }
      if room.nil?
        raise ArgumentError.new("Not a valid room number")
      end
    end
  end
end
