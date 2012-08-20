require 'json'
require_relative '../lib/temperature_store'

class TestClock < DateTime
  def now
    self 
  end
end

describe TemperatureStore do
  after do
    Redis.new.del(:test)
  end

  it "saves temperatures and conditions" do
    clock = TestClock.new(2012, 8, 17, 11, 34)
    temperatures = {pool: 79, outside: 24, condition: :cloudy}
    TemperatureStore.save(temperatures, :test, clock).should be true 
  end

  context "reads in temperatures from the store" do
    it "gets only the latest temperatures" do
      [{m:34, t:80},{m:39, t:81},{m:44, t:82}].each do |value|
        clock = TestClock.new(2012, 8, 17, 11, value[:m])
        temperature = {pool: value[:t], outside: 24, condition: 'cloudy'}
        TemperatureStore.save(temperature, :test, clock)
      end

      TemperatureStore.latest(:test)[:pool].should == 82 
    end
  end
end
