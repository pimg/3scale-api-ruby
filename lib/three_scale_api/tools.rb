# frozen_string_literal: true

require 'logger'
module ThreeScaleApi
  # Basic tools module
  module Tools
    # Basic Logging Factory
    class LoggingFactory
      # @api public
      # Creates basic logging factory
      #
      # @param [String] log_level Logging level, default is 'debug'
      def initialize(log_level: 'debug')
        @log_level = log_level
      end

      # @api public
      # Gets logging logging level number
      #
      # @param [String] log_level Logging level as string is 'debug'
      # @return [Fixnum] Log level id
      def self.get_level(log_level = 'debug')
        Logger.const_get log_level.upcase
      rescue NameError
        Logger::DEBUG
      end

      # @api public
      # Creates a instance of logger using in config information
      #
      # @param [String] log_level Override default log level using in config or ENV
      # @return [Logger] Logger instance
      def get_instance(log_level: nil, name: nil)
        logger = Logger.new(STDOUT)
        logger.progname = name if name
        log_level = log_level || @log_level || ENV['THREESCALE_LOG'] || 'debug'
        logger.level = LoggingFactory.get_level(log_level)
        logger
      end
    end

    # @api public
    # Creates logging factory
    #
    # @param [String] log_level Logging level as string, default is 'debug'
    def self.log_factory(log_level: 'debug')
      LoggingFactory.new(log_level: log_level)
    end

    # @api public
    # Checks response whether it contains error attribute
    #
    # @param [Hash] response Response from server
    def self.check_response(response)
      if (response.is_a? Hash) && (response['error'] || response['errors'])
        raise APIResponseError.new(response), (response['error'] || response['errors'])
      end
      response
    end

    # @api public
    # Extracts Hash from response
    #
    # @param [String] collection Collection name
    # @param [String] entity Entity name
    # @param [object] from Response
    def self.extract(collection: nil, entity:, from:)
      from = from.fetch(collection) if collection

      response = case from
                 when Array then from.map { |e| e.fetch(entity) }
                 when Hash then from.fetch(entity) { from }
                 when nil then nil # raise exception?
                 else raise "unknown #{from}"
                 end

      check_response(response)
    end

    # Custom error that is thrown when the
    class APIResponseError < StandardError
      attr_reader :entity

      def initialize(entity)
        @entity = entity
      end
    end
  end
end
