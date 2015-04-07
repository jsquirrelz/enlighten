require_relative 'test_helper'

describe Utils do
  include Utils

  describe 'date_format' do
    it "should format a date" do
      date = DateTime.parse('2014-12-31')
      date_format(date).must_equal('2014-12-31')
    end
    it "should pass through a string" do
      date_format('2014-12-31').must_equal('2014-12-31')
    end
  end

  describe 'query_string' do
    it "should return a valid query string if given a valid hash" do
      query_string({:a=>'1',:b=>'2',:c=>'3'}).must_equal('a=1&b=2&c=3')
    end

    it "should CGI Encode the query string" do
      query_string({:a=>'1',:b=>'2&2',:c=>'3/3'}).must_equal('a=1&b=2%262&c=3%2F3')
    end
  end


end