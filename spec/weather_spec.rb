require 'spec_helper'
require_relative '../lib/weather'


describe Weather do

  before do
    VCR.use_cassette('weather') do
      @weather = Weather.new
    end
  end

  it "gives the current temperature for montreal" do
    @weather.temperature.should == 21
  end

  it "gives the current condition for montreal" do
    @weather.condition.should == :cloudy 
  end
end
