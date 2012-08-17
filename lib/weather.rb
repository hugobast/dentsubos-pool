require 'json'
require 'faraday'
require_relative 'codes'

class Weather
  def initialize
    connection = Faraday.new('http://www.theweathernetwork.com')
    response = connection.get('/dataaccess/citypage/json/caqc0363')
    @data = JSON::parse(response.body)
  end

  def temperature
    @data["PACKAGE"]["Observation"]["temperature_c"]
  end

  def condition
    code = @data["PACKAGE"]["Observation"]["icon"]
    Condition.for(code) 
  end
end

