# frozen_string_literal: true

require 'three_scale_api/clients/default_helpers'

module ThreeScaleApi
  module Clients
    # Service plan resource manager wrapper for the service plan entity received by the REST API
    class ServicePlanManager < DefaultPlanManager
      attr_accessor :service

      # @api public
      # Creates instance of the Proxy resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      def initialize(http_client, service = nil)
        super(http_client, entity_name: 'service_plan', collection_name: 'plans')
        @service = service
        @resource_instance = ServicePlan
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service['id']}/service_plans"
      end

      # @api public
      # Lists all service plans
      #
      # @return [Array<ServicePlan>] List of ServicePlans
      def list_all
        super('/admin/api/service_plans')
      end
    end

    # Service plan resource wrapper for proxy entity received by REST API
    class ServicePlan < DefaultPlanResource
      attr_accessor :service

      # @api public
      # Construct the proxy resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ServicePlanManager] manager Instance of the manager
      # @param [Hash] entity Entity Hash from API client of the proxy
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end
    end
  end
end
