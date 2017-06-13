# frozen_string_literal: true

require 'three_scale_api/resources/default'
module ThreeScaleApi
  module Resources
    # WebHook resource wrapper for the WebHook entity received by the REST API
    class WebHook < DefaultResource
      attr_accessor :service

      # @api public
      # Construct the WebHook resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [WebHookClient] manager Instance of the webhook manager
      # @param [Hash] entity Entity Hash from API client of the metric
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end
    end
  end
end
