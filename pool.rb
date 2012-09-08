require 'eventmachine'
require 'em-websocket'
require 'sinatra/base'
require_relative 'lib/pool'

EM.run do
  class Pool < Sinatra::Base
    get '/now' do
      temperature = TemperatureStore.latest 
      @pool = $pool
      @outside = temperature[:outside]
      @condition = temperature[:condition]
      erb :index
    end
  end

  @channel = EM::Channel.new

  EM::WebSocket.start host: '0.0.0.0', port: 8806 do |socket|
    socket.onopen do
      sid = @channel.subscribe { |data| socket.send data }
      puts "client connected!"

      socket.onclose do
        @channel.unsubscribe sid
      end
    end
  end

  module TemperatureReceiver
    attr_accessor :channel

    def post_init
      puts "arduino connected!"
    end

    def receive_data data
      begin
        $pool = JSON.parse(data)["temperature"]
      rescue JSON::ParserError
        puts 'error generated from JSON::ParserError'
      end
      channel.push data
    end
  end

  EM.start_server "0.0.0.0", 8805, TemperatureReceiver do |connection|
    connection.channel = @channel
  end

  Pool.run!
end
