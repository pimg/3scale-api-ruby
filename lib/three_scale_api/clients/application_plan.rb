# frozen_string_literal: true

require 'three_scale_api/clients/default_helpers'
require 'three_scale_api/clients/application_plan_limit'

module ThreeScaleApi
  module Clients
    # Application plan resource manager wrapper for an application plan entity
    # received by the REST API
    class ApplicationPlanManager < DefaultPlanManager
      attr_accessor :service
      # @api public
      # Creates instance of the application plan resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      # @param [ThreeScaleQE::Clients::Service] service Service resource
      def initialize(http_client, service = nil)
        super(http_client, entity_name: 'application_plan', collection_name: 'plans')
        @service = service
        @resource_instance = ApplicationPlan
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service['id']}/application_plans"
      end

      # @api public
      # Lists all application plans
      #
      # @return [Array<ServicePlan>] List of Application plans
      def list_all
        super('/admin/api/application_plans')
      end
    end

    # Application plan resource wrapper for an application entity received by the REST API
    class ApplicationPlan < DefaultPlanResource
      attr_accessor :service

      # @api public
      # Construct the proxy resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ThreeScaleApi::Clients::DefaultManager] manager Instance of test client
      # @param [Hash] entity Entity Hash from API client of the proxy
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end

      # @api public
      # Gets instance of the limits manager
      #
      # @return [ApplicationPlanLimitManager] Application plan limit manager
      # @param [Metric] metric Metric resource
      def limits(metric = nil)
        manager_instance(ApplicationPlanLimitManager, metric: metric)
      end
    end
  end
end
