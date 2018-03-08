module Hotel
  STANDARD_RATE = 200

  class Room
    attr_reader :room_id, :cost, :reservations, :blocks

    def initialize(input) # taking a hash so that an array of reservations can be loaded if that's what user wants to do
      @room_id = input[:id]
      @cost = STANDARD_RATE
      @reservations = input[:reservations] == nil ? [] : input[:reservations] # setting the default to an empty array if no reservations for that room
      @blocks = []
    end

    def check_availability(start_date, end_date, block_last_name: nil) # should this be a date or string instance?
      start_date = Date.parse(start_date)
      end_date = Date.parse(end_date)

      # if there already is a reservation, then this room is not available
      @reservations.each do |reservation|
        # range = (reservation.start_date..reservation.end_date)
        if overlap_date_range?(start_date, end_date, reservation)
          return :UNAVAILABLE
        end
      end

      check_for_block(start_date, end_date, block_last_name: block_last_name)
    end

    def add_reservation(reservation)
      @reservations << reservation
    end

    def add_block(block)
      @blocks << block
    end

    private

    def check_for_block(start_date, end_date, block_last_name: nil)

      if block_last_name.nil? # if not part of a block
        # find reservations that might overlap/contain this date range
        overlapping_blocks = @blocks.select do |block|
          overlap_date_range?(start_date, end_date, block)
        end

        if overlapping_blocks.empty?
          return :AVAILABLE
        else
          raise NoAvailableRoom.new("This room is not available for reserving")
        end

      else
        selected_block = @blocks.find {|block| block.start_date == start_date && block.block_last_name == block_last_name}

        if selected_block.nil? # this is not defensive
          return :UNAVAILABLE
        else
          return :AVAILABLE
        end

      end
    end

    def overlap_date_range?(start_date, end_date, block_res)
      reservation_range = (block_res.start_date...block_res.end_date).to_a
      check_range = (start_date...end_date).to_a
      overlap = reservation_range & check_range
      if !overlap.empty?
        return true
      else
        return false
      end
    end

  end # class
end # module
