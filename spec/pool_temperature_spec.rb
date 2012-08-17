require 'spec_helper'
require_relative '../lib/pool_temperature'

describe PoolTemperature do
  it "fetches the pool temperature" do
    VCR.use_cassette('temperature') do
      PoolTemperature.new.read.should == 79
    end 
  end
end
