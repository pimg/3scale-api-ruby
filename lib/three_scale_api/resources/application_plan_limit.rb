# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    class ApplicationPlanLimit < DefaultResource
      attr_accessor :service, :metric

      # @api public
      # Construct an application plan limit resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ApplicationPlanLimitClient] manager Instance of the manager
      # @param [Hash] entity Entity Hash from API client of the application plan limit
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
        @metric = manager.metric
        @application_plan = manager.application_plan
      end
    end
  end
end
