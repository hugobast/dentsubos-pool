require_relative '../lib/pool_temperature_cache'

describe PoolTemperatureCache do
  it "stores readings" do
    temperature = 81
    Redis.should_receive
    cache = PoolTemperatureCache.new.store temperature
  end
    

  it "retreives latest readings"
end
