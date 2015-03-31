require 'minitest/spec'
require 'minitest/autorun'
require_relative '../lib/enlighten'


describe Enlighten do

  it "should initalize with default params" do
    Enlighten::System.url.must_equal "https://api.enphaseenergy.com/api/v2/systems"
  end

  it "should should override the default params" do
    Enlighten::System.config(host: 'bogus.enphaseenergy.com', path: '/bogus/v2/bogus')
    Enlighten::System.url.must_equal "https://bogus.enphaseenergy.com/bogus/v2/bogus"
    Enlighten::System.config(host: 'api.enphaseenergy.com', path: '/api/v2/systems')
  end

  describe "Function Calls" do

    before do
      Enlighten::System.config(key: '0960c4df1203f3079489fa8ccc251b59', user_id: '4d7a45774e6a41320a')
    end


    it "should return a system summary upon creation" do
      system = Enlighten::System.new(67)
      system.summary.system_id.must_equal 67
    end

    it "should return system stats upon request" do
      system = Enlighten::System.new(67)
      system.stats.total_devices.must_equal 35
    end

    it "should return system inventory upon request" do
      system = Enlighten::System.new(67)
      system.inventory.envoys[0]['sn'].must_equal "121112607295"
    end
    it "should return energy_lifetime upon request" do
      system = Enlighten::System.new(67)
      system.energy_lifetime.start_date.must_equal "2008-01-26"
    end


  end
 end