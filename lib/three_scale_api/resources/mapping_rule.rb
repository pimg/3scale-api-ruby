# frozen_string_literal: true

require 'three_scale_api/resources/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'

module ThreeScaleApi
  module Resources
    # MappingRule resource wrapper for the MappingRule entity received by the REST API
    class MappingRule < DefaultResource
      attr_accessor :service, :metric

      # @api public
      # Construct the MappingRule resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [ThreeScaleApi::Clients::MappingRuleClient] manager Mapping rule manager
      # @param [Hash] entity Entity Hash from the API client of the MappingRule
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
        @metric = manager.metric
      end
    end
  end
end
