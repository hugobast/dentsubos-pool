require 'sinatra'
require_relative 'lib/pool'

get '/now' do
  temperature = TemperatureStore.latest 
  @pool = temperature[:pool]
  @outside = temperatur[:outside]
  @condition = temperature[:condition]
  erb :index
end
