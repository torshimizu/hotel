module Hotel
  class Room
    attr_reader :room_id, :status
    
    def initialize(id)
      @room_id = id
      @status ||= :AVAILABLE
    end
  end
end
