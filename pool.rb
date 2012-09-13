require 'logger'
require 'eventmachine'
require 'em-websocket'
require 'sinatra/base'
require_relative 'lib/pool'

$logger = Logger.new(STDOUT)

EM.run do
  class Pool < Sinatra::Base
    get '/now' do
      temperature = TemperatureStore.latest 
      @pool = $pool || 76
      @outside = temperature[:outside]
      @condition = temperature[:condition]
      erb :index
    end
  end

  @channel = EM::Channel.new

  EM::WebSocket.start host: '0.0.0.0', port: 8806 do |socket|
    socket.onopen do
      sid = @channel.subscribe { |data| socket.send data }

      socket.onclose do
        @channel.unsubscribe sid
      end
    end
  end

  module TemperatureReceiver
    attr_accessor :channel

    def receive_data data
      data = data.force_encoding('utf-8')
      begin
        $pool = JSON.parse(data.chomp)["temperature"]
      rescue JSON::ParserError
        # ignore it depending on the sketch it's not needed
      end
      channel.push data
    end
  end

  EM.start_server "0.0.0.0", 8805, TemperatureReceiver do |connection|
    connection.channel = @channel
  end

  Pool.run!
end