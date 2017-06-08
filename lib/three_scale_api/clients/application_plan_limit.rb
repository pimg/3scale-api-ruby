# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/application_plan_limit'

module ThreeScaleApi
  module Clients
    # Application plan limit resource manager wrapper for an application plan limit entity
    # received by the REST API
    class ApplicationPlanLimitClient < DefaultClient
      attr_accessor :service, :application_plan, :metric

      # @api public
      # Creates instance of the application plan resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      # @param [ThreeScaleQE::Clients::ApplicationPlan] app_plan Service resource
      def initialize(http_client, app_plan = nil, metric: nil)
        super(http_client, entity_name: 'limit')
        @service = app_plan.service
        @application_plan = app_plan
        @metric = metric
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        app_plan = application_plan.entity_id
        super.concat "/application_plans/#{app_plan}/metrics/#{metric.entity_id}/limits"
      end

      # @api public
      # Binds metric to Application plan limit
      #
      # @param [Metric] metric Metric resource
      def set_metric(metric)
        @metric = metric
      end
    end
  end
end
