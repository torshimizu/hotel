module Hotel
  class DateHelper
    def self.parse(date)
      case
      when date.instance_of?(Date)
        return date
      when date.match(/^\d{2,4}-\d{1,2}-\d{1,2}$/)
        Date.parse(date)
      when date.match(/^\d{1,2}-\d{1,2}-\d{4}$/)
        Date.strptime(date, '%m-%d-%Y')
      when date.match(/^\d{1,2}\/\d{1,2}\/\d{4}$/)
        Date.strptime(date, '%m/%d/%Y')
      when date.match(/^\d{6,8}$/)
        Date.parse(date)
      end
    end


    def self.overlap_date_range?(start_date, end_date, block_res)
      reservation_range = (block_res.start_date...block_res.end_date).to_a
      check_range = (parse(start_date)...parse(end_date)).to_a
      overlap = reservation_range & check_range
      return !overlap.empty?
    end
  end # class
end # module
