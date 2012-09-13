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
      $logger.info "websocket client connected!"

      socket.onclose do
        @channel.unsubscribe sid
      end
    end
  end

  module TemperatureReceiver
    attr_accessor :channel

    def post_init
      $logger.info "arduino connected!"
    end

    def unbind
      $logger.info "arduino disconnected!"
    end

    def receive_data data
      data = data.force_encoding('utf-8')
      data = data.chomp
      begin
        $pool = JSON.parse(data)["temperature"]
      rescue JSON::ParserError
        $logger.error 'error generated from JSON::ParserError'
      end
      $logger.info "received #{data}"
      channel.push data
    end
  end

  EM.start_server "0.0.0.0", 8805, TemperatureReceiver do |connection|
    connection.channel = @channel
  end

  Pool.run!
end
