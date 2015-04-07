require_relative 'test_helper'
require 'date'

describe Enlighten do
  describe Enlighten::System do
    it "should initalize with default params" do
      Enlighten::System.url.must_equal "https://api.enphaseenergy.com/api/v2/systems"
    end
    it "should should override the default params" do
      Enlighten::System.config(host: 'bogus.enphaseenergy.com', path: '/bogus/v2/bogus')
      Enlighten::System.url.must_equal "https://bogus.enphaseenergy.com/bogus/v2/bogus"
      Enlighten::System.config(host: 'api.enphaseenergy.com', path: '/api/v2/systems')
    end

    describe "Function Calls" do
      let(:system){ Enlighten::System.new(67)}
      before do
        #my key with the test user id
        Enlighten::System.config(key: '0960c4df1203f3079489fa8ccc251b59', user_id: '4d7a45774e6a41320a')
      end
      it "should format the url" do
        system.send(:format_url,:summary).must_equal('https://api.enphaseenergy.com/api/v2/systems/summary?key=0960c4df1203f3079489fa8ccc251b59&user_id=4d7a45774e6a41320a')
      end
      it "should format the url with parameters" do
        system.send(:format_url,:energy_lifetime,start_date: '2010-01-01',end_date: '2010-12-31').must_equal(
            "https://api.enphaseenergy.com/api/v2/systems/energy_lifetime?key=0960c4df1203f3079489fa8ccc251b59&user_id=4d7a45774e6a41320a&start_date=2010-01-01&end_date=2010-12-31"
        )
      end
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

      it "should 'find' a system" do
        system = Enlighten::System.find(67)
        system.stub(:api_response, load_fixture(:summary)) do
          system.summary.system_id.must_equal 67
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
    end
  end
 end