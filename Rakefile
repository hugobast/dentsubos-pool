require_relative 'lib/pool'

task :cache_weather do
  weather = Weather.new
  pool = PoolTemperature.new
  data = {
    pool: pool.read, 
    condition: weather.condition, 
    outside: weather.temperature
  }
  TemperatureStore.save data
end
