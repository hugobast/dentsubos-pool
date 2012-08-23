require_relative 'lib/pool'

task :cache_weather do
  weather = Weather.new
  data = {
    condition: weather.condition, 
    outside: weather.temperature
  }
  TemperatureStore.save data
end
