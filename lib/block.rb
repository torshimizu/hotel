module Hotel
  class Block
    attr_reader :start_date, :end_date, :block_rooms, :rate, :block_last_name

    def initialize(input)
      @rate = input[:rate]
      @start_date = Date.parse(input[:start_date])
      @end_date = Date.parse(input[:end_date])
      @block_rooms = check_room_count(input[:block_rooms]) # wouldn't I want this to take room_id's not rooms? or will the rooms be found in admin
      @block_last_name = input[:block_last_name]

      if @block_last_name.nil?
        raise StandardError.new("Must enter a last name")
      end
    end

    def check_room_count(block_rooms)
      if block_rooms.length > 5
        raise StandardError.new("Invalid number of rooms: #{block_rooms.length}. A block can only have up to 5 rooms.")
      end
      return block_rooms
    end

  end
end
