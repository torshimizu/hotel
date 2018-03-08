module Hotel
  class DateHelper
    def self.parse(date)
      case
      # when !Date.valid_date?(date)
      #   raise ArgumentError.new("Not a valid date")
      when date.instance_of?(Date)
        return date
      when date.match(/\d{2,4}-\d{1,2}-\d{1,2}/)
        Date.parse(date)
      when date.match(/\d{1,2}-\d{1,2}-\d{4}/)
        Date.strptime(date, '%d-%m-%Y')
      when date.match(/\d{1,2}\/\d{1,2}\/\d{4}/)
        Date.strptime(date, '%m/%d/%Y')
      when date.match(/\d{6,8}/)
        Date.parse(date)
      end
    end
  end # class
end # module
