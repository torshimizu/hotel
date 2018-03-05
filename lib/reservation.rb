require 'date'

module Hotel
  class Reservation
    attr_reader :room_id, :start_date, :end_date, :guest_last_name

    def initialize(input)
      @start_date = Date.parse(input[:start_date])
      @end_date = Date.parse(input[:end_date])
      @room_id = input[:room_id] # might need to consider multiple rooms?
      @guest_last_name = input[:guest_last_name]
      @guest_first_name = input[:guest_first_name].nil? ? nil : input[:guest_first_name]


      if (@start_date == nil || @end_date == nil) || @start_date > @end_date
        raise StandardError.new("Invalid dates")
      end
    end
  end
end
