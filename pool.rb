require 'sinatra'
require_relative 'lib/weather'
require_relative 'lib/pool_temperature'

get '/now' do
  # fetch data from the pool
  @pool_temperature = PoolTemperature.read 
  # fetch data from weatherbug
  @weather = Weather.new
  erb :index
end
