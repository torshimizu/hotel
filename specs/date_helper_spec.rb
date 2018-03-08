require_relative 'spec_helper'

describe Hotel::DateHelper do

  describe "DateHelper.parse" do
    it "must take in a string and return an instance of date" do
      date1 = "2018-03-05"
      Hotel::DateHelper.parse(date1).must_be_instance_of Date
    end

    it "can parse various versions of a date string" do
      date1 = "05/03/2018"
      date_1 = Hotel::DateHelper.parse(date1)
      date_1.must_be_instance_of Date

      date2 = "05-03-2018"
      date_2 = Hotel::DateHelper.parse(date2)
      date_2.must_be_instance_of Date
    end

    it "can handle an instance of date" do
      date1 = Date.new(2018,03,05)
      date_1 = Hotel::DateHelper.parse(date1)
      date_1.must_be_instance_of Date
    end
  end

end
