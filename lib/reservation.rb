module Hotel
  class Reservation
    attr_reader :room, :start_date, :end_date, :guest_last_name, :room_id, :cost

    def initialize(input)
      @start_date = DateHelper.parse(input[:start_date])
      @end_date = DateHelper.parse(input[:end_date])
      @room = input[:room].nil? ? nil : input[:room]
      @room_id = input[:room_id]
      @guest_last_name = input[:guest_last_name]
      @guest_first_name = input[:guest_first_name].nil? ? nil : input[:guest_first_name]
      @cost = input[:cost] || STANDARD_RATE

      if (@start_date == nil || @end_date == nil) || @start_date > @end_date
        raise StandardError.new("Invalid dates")
      end

      if @guest_last_name.nil?
        raise StandardError.new("Must enter a last name")
      end

      if @room_id.nil?
        raise StandardError.new("Must enter a room number")
      end
    end

    def calculate_cost 
      duration = (@end_date - @start_date).to_i
      return (duration * @cost).to_f.round(2)
    end

  end # Reservation
end # Hotel
