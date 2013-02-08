require 'eventmachine'

module EventMachine
  module Hiredis
    # All em-hiredis errors should descend from EM::Hiredis::Error
    class Error < RuntimeError; end

    # In the case of error responses from Redis, the RuntimeError returned
    # by ::Hiredis will be wrapped
    class RedisError < Error
      attr_accessor :redis_error
    end

    class << self
      attr_accessor :reconnect_timeout
    end
    self.reconnect_timeout = 0.5

    def self.setup(uri = nil)
      uri = uri || ENV["REDIS_URL"] || "redis://127.0.0.1:6379/0"
      client = Client.new
      client.configure(uri)
      client
    end

    def self.connect(uri = nil)
      client = setup(uri)
      client.connect
      client
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.logger
      @@logger ||= begin
        require 'logger'
        log = Logger.new(STDOUT)
        log.level = Logger::WARN
        log
      end
    end
  end
end

require 'em-hiredis/event_emitter'
require 'em-hiredis/connection'
require 'em-hiredis/base_client'
require 'em-hiredis/client'
require 'em-hiredis/pubsub_client'
require 'em-hiredis/lock'
