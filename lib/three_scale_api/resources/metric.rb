# frozen_string_literal: true

require 'three_scale_api/resources/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'

module ThreeScaleApi
  module Resources
    # Metric resource wrapper for the metric entity received by the REST API
    class Metric < DefaultResource
      attr_accessor :service

      # @api public
      # Construct the metric resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [ThreeScaleApi::Clients::MetricClient] manager Metrics manager
      # @param [Hash] entity Entity Hash from API client of the metric
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end

      # @api public
      # Gets application plan limits
      #
      # @return [ApplicationPlanLimitClient] Instance of the Application plan limits manager
      def application_plan_limits(app_plan)
        ApplicationPlanLimitClient.new(@http_client, app_plan, metric: self)
      end

      # @api public
      # Gets methods manager
      #
      # @return [MethodsManager] Instance of the Methods manager
      def methods
        manager_instance(:Method)
      end
    end
  end
end
