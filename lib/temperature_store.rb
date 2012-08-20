require 'redis'
require 'date'

class TemperatureStore
  def self.save(temperatures, set = :temperature, clock = DateTime) 
    redis.zadd @set, key(clock), temperatures.to_json
  end

  def self.latest(set = :temperature)
    JSON.parse(redis.zrevrange(set, 0, 0).first, symbolize_names: true)
  end

  private
 
  def self.redis
    @redis ||= Redis.new
  end

  def self.key(clock)
    clock.now.strftime('%y%m%d%H%M')
  end
end
