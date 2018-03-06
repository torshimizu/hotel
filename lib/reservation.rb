require 'date'

module Hotel
  class Reservation
    attr_reader :room, :start_date, :end_date, :guest_last_name, :room_id

    def initialize(input)
      @start_date = Date.parse(input[:start_date])
      @end_date = Date.parse(input[:end_date])
      @room = input[:room].nil? ? nil : input[:room]
      @room_id = input[:room_id]
      @guest_last_name = input[:guest_last_name]
      @guest_first_name = input[:guest_first_name].nil? ? nil : input[:guest_first_name]
      @block = input[:block].nil? ? nil : input[:block]

      if (@start_date == nil || @end_date == nil) || @start_date > @end_date
        raise StandardError.new("Invalid dates")
      end

      if @guest_last_name.nil?
        raise StandardError.new("Must enter a last name")
      end
    end

    def calculate_cost
      duration = (@end_date - @start_date).to_i
      return (duration * STANDARD_RATE).to_f.round(2)
    end

  end # Reservation
end # Hotel
