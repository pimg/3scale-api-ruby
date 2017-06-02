# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    # @api public
    # Proxy resource wrapper for proxy entity received by REST API
    class Proxy < DefaultResource
      attr_accessor :service

      # @api public
      # Construct the proxy resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ThreeScaleApi::Clients::DefaultClient] manager Instance of the manager
      # @param [Hash] entity Entity Hash from API client of the proxy
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end

      # @api public
      # Updates proxy
      def update
        @manager.update(entity)
      end
    end
  end
end
