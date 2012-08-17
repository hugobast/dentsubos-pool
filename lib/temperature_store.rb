require 'redis'
require 'date'

class TemperatureStore
  def self.save(temperatures, set = :temperature, clock = DateTime) 
    @clock = clock; @set = set
    redis.zadd @set, key, temperatures.to_json
  end

  def self.latest
    JSON.parse(redis.zrevrange(@set, 0, 0).first, symbolize_names: true)
  end

  private
 
  def self.redis
    @redis ||= Redis.new
  end

  def self.key
    @clock.now.strftime('%H%M')
  end
end
