require_relative 'test_helper'
require 'date'


describe Enlighten::System do
  include Enlighten

  let(:system){
    Enlighten::System.stub_any_instance(:api_response,load_fixture(:index)) do
      Enlighten::System.new(:id=>67)
    end
  }
  before do
    #my key with the test user id
    Enlighten::System.config(key: 'abc123', user_id: '123abc')
  end
  it "should initalize with default params" do
    Enlighten::System.url.must_equal "https://api.enphaseenergy.com/api/v2/systems"
  end
  it "should should override the default params" do
    Enlighten::System.config(host: 'bogus.enphaseenergy.com', path: '/bogus/v2/bogus')
    Enlighten::System.url.must_equal "https://bogus.enphaseenergy.com/bogus/v2/bogus"
    Enlighten::System.config(host: 'api.enphaseenergy.com', path: '/api/v2/systems')
  end

  describe "Function Calls" do


    describe 'format_url' do
      it "should format the url" do
        system.send(:format_url,:summary).must_equal('https://api.enphaseenergy.com/api/v2/systems/67/summary?key=abc123&user_id=123abc')
      end
      it "should format the url with parameters" do
        system.send(:format_url,:energy_lifetime,start_date: '2010-01-01',end_date: '2010-12-31').must_equal(
            "https://api.enphaseenergy.com/api/v2/systems/67/energy_lifetime?key=abc123&user_id=123abc&start_date=2010-01-01&end_date=2010-12-31"
        )
      end
      it "should format the url with Time parameters" do
        start_date = DateTime.parse('2010-01-01')
        end_date = DateTime.parse('2010-12-31')

        system.send(:format_url,:energy_lifetime,start_date: start_date,end_date: end_date).must_equal(
            "https://api.enphaseenergy.com/api/v2/systems/67/energy_lifetime?key=abc123&user_id=123abc&start_date=2010-01-01&end_date=2010-12-31"
        )
      end
      it "should format the url with 'start_at', and 'end_at' parameters" do
        system.send(:format_url,:stats,start_at: DateTime.strptime('2015-01-01 00:00','%Y-%m-%d %H:%M').to_time,end_at: DateTime.strptime('2015-01-02 00:00', '%Y-%m-%d %H:%M').to_time).must_equal(
            "https://api.enphaseenergy.com/api/v2/systems/67/stats?key=abc123&user_id=123abc&start_at=1420070400&end_at=1420156800"
        )
      end
      it "should format an index url if given nil params" do
          system.send(:format_url,nil,nil).must_equal(
              "https://api.enphaseenergy.com/api/v2/systems/?key=abc123&user_id=123abc"
          )
      end

    end

    describe 'date_format' do
      it "should format a date" do
        date = DateTime.parse('2014-12-31')
        system.send(:date_format, date).must_equal('2014-12-31')
      end
      it "should pass through a string" do
        system.send(:date_format, '2014-12-31').must_equal('2014-12-31')
      end
    end

    describe 'query_string' do
      it "should return a valid query string if given a valid hash" do
        system.send(:query_string,{:a=>'1',:b=>'2',:c=>'3'}).must_equal('a=1&b=2&c=3')
      end

      it "should CGI Encode the query string" do
        system.send(:query_string,{:a=>'1',:b=>'2&2',:c=>'3/3'}).must_equal('a=1&b=2%262&c=3%2F3')
      end
    end
  end

  describe 'attributes' do
    it "should set a system_id" do
      system.system_id.must_equal 67
    end
    it "should set a system_name" do
      system.system_name.must_equal "Eich Residence"
    end
    it "should set a system_public_name" do
      system.system_public_name.must_equal "Eich Residence"
    end
    it "should set a status" do
      system.status.must_equal "normal"
    end
    it "should set a timezone" do
      system.timezone.must_equal "America/Los_Angeles"
    end
    it "should set a country" do
      system.country.must_equal "US"
    end
    it "should set a state" do
      system.state.must_equal "CA"
    end
    it "should set a city" do
      system.city.must_equal"Sebastopol"
    end
    it "should set a connection_type" do
      system.connection_type.must_equal "ethernet"
    end
    it "should set other_references" do
      system.other_references.must_equal ["Solarfox"]
    end
    it "should set a postal_code" do
      system.postal_code.must_equal "95472"
    end
  end

  describe 'REST end points' do
    it "should return a system summary upon creation" do
        system.stub(:api_response, load_fixture(:summary)) do
          system.summary.system_id.must_equal 67
        end
      end

      it "should return system stats upon request" do
        system.stub(:api_response, load_fixture(:stats)) do
          system.stats.total_devices.must_equal 35
        end
      end

      it "should return system inventory upon request" do
        system.stub(:api_response, load_fixture(:inventory)) do
          system.inventory.envoys[0]['sn'].must_equal "121112607295"
        end
      end
      it "should return energy_lifetime upon request" do
        system.stub(:api_response, load_fixture(:energy_lifetime)) do
          system.energy_lifetime.start_date.must_equal "2010-01-01"
        end
      end
    it "should return cached energy_lifetime upon request" do
      system.stub(:api_response, load_fixture(:energy_lifetime)) do
        system.energy_lifetime.start_date.must_equal "2010-01-01"
      end
      system.energy_lifetime.start_date.must_equal "2010-01-01"
    end
      it "should 'find' a system" do
        Enlighten::System.stub_any_instance(:api_response,load_fixture(:index)) do
          new_system = Enlighten::System.find(67)
          new_system.system_id.must_equal 67
        end
      end

      it "should return a date range for enery lifetime." do
        system.stub(:api_response, load_fixture(:energy_lifetime)) do
          start_date = DateTime.parse("2010-01-01")
          end_date = DateTime.parse("2010-12-31")
          system.energy_lifetime(start_date: start_date, end_date: end_date).start_date.must_equal "2010-01-01"
        end
      end

      it "should return a date range for enery lifetime if passed strings." do
        system.stub(:api_response, load_fixture(:energy_lifetime)) do
          system.energy_lifetime(start_date: "2010-01-01", end_date: "2010-12-31").start_date.must_equal "2010-01-01"
        end
      end

      it "should raise an exception if an error code is returned." do
        system.stub(:api_response, load_fixture(:error)) do
          proc{system.summary}.must_raise Enlighten::EnlightenApiError
        end
      end
    end
  end


