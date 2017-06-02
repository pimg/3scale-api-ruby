# frozen_string_literal: true

require 'three_scale_api/resources/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'

module ThreeScaleApi
  module Resources
    # @api public
    # Method resource wrapper for the metric entity received by the REST API
    class Method < DefaultResource
      attr_accessor :service, :metric

      # Construct the metric resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [ThreeScaleApi::Clients::MethodClient] manager Method manager
      # @param [Hash] entity Entity Hash from API client of the metric
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
        @metric = manager.metric
      end

      # @api public
      # Gets application plan limits
      #
      # @return [ApplicationPlanLimitClient] Instance of the Application plan limits manager
      def application_plan_limits(app_plan)
        ApplicationPlanLimitClient.new(@http_client, app_plan, metric: self)
      end
    end
  end
end
