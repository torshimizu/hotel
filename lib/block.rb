module Hotel
  class Block
    attr_reader :start_date, :end_date, :block_rooms, :rate
    
    def initialize(input)
      @start_date = input[:start_date]
      @end_date = input[:end_date]
      @block_rooms = input[:block_rooms]
      @rate = input[:rate]
    end
  end
end
