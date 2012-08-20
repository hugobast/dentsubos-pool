require 'sinatra'
require_relative 'lib/pool'

get '/now' do
  temperature = TemperatureStore.latest 
  @pool = temperature[:pool]
  @outside = temperature[:outside]
  @condition = temperature[:condition]
  erb :index
end
