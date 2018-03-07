module Hotel
  class Block
    attr_reader :start_date, :end_date, :block_rooms, :rate

    def initialize(input)
      @rate = input[:rate]
      @start_date = input[:start_date]
      @end_date = input[:end_date]
      @block_rooms = check_room_count(input[:block_rooms]) # wouldn't I want this to take room_id's not rooms? or will the rooms be found in admin
      @guest_last_name = input[:guest_last_name]
    end

    def check_room_count(block_rooms)
      if block_rooms.length > 5
        raise StandardError.new("Invalid number of rooms: #{block_rooms.length}. A block can only have up to 5 rooms.")
      end
      return block_rooms
    end

  end
end