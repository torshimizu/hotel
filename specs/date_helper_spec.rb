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

  describe "DateHelper.overlap_date_range?" do
    before do
      @admin = Hotel::Admin.new(5)
      @input = {start_date: "2018-03-05", end_date: "2018-03-08", guest_last_name: "Hopper"}
      @reservation1 = @admin.new_reservation(@input)
    end

    it "will return true if two date ranges overlap" do
      Hotel::DateHelper.overlap_date_range?("2018-03-07", "2018-03-10", @reservation1).must_equal true
    end
  end

end
