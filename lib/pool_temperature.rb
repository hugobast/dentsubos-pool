require 'faraday'
require 'json'

class PoolTemperature
  def initialize(url = 'http://192.168.3.11')
    @connection = Faraday.new(url)
  end

  def read
    response = @connection.get('/temperature.json')
    @temperature = temperature(response.body)
  end

  def self.save
    
  end

  private

  def temperature(response)
    parse(response)['temperature']
  end

  def parse(json)
    JSON.parse(json) 
  end
end
