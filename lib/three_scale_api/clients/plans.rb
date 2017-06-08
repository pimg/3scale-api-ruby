# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/plans'

module ThreeScaleApi
  module Clients
    # Default plan resource manager wrapper
    module DefaultPlanClient
      # @api public
      # Lists all plans
      #
      # @return [Array<DefaultPlan>] List of DefaultPlans
      def list_all(path = nil)
        @log.info("List all #{resource_name}s")
        response = @http_client.get(path)
        log_result resource_list(response)
      end

      # @api public
      # Sets global default plan
      #
      # @param [Fixnum] id Plan ID
      # @return [DefaultPlanResource] DefaultPlan plan instance
      def set_default(id)
        @log.debug("Set default #{resource_name}: #{id}")
        response = @http_client.put("#{base_path}/#{id}/default")
        log_result resource_instance(response)
      end

      # @api public
      # Gets global default plan
      #
      # @return [DefaultPlanResource] Default plan plan instance
      def get_default
        @log.info("Get default #{resource_name}:")
        result = nil
        _list.each do |plan|
          result = plan if plan['default']
        end
        log_result result
      end
    end

    # Application plan resource manager wrapper for an application plan entity
    # received by the REST API
    class ApplicationPlanClient < DefaultClient
      include DefaultPlanClient

      attr_accessor :service
      # @api public
      # Creates instance of the application plan resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      # @param [ThreeScaleQE::Clients::Service] service Service resource
      def initialize(http_client, service = nil)
        super(http_client, entity_name: 'application_plan', collection_name: 'plans')
        @service = service
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

    # Account plan resource manager wrapper for account plan entity received by REST API
    class AccountPlanClient < DefaultClient
      include DefaultPlanClient
      # @api public
      # Creates instance of the Account resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'account_plan', collection_name: 'plans')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/account_plans'
      end

      # @api public
      # Lists all account plans
      #
      # @return [Array<ServicePlan>] List of AccountPlans
      def list_all
        super(base_path)
      end
    end

    # Service plan resource manager wrapper for the service plan entity received by the REST API
    class ServicePlanClient < DefaultClient
      include DefaultPlanClient
      attr_accessor :service

      # @api public
      # Creates instance of the Proxy resource manager
      #
      # @param [ThreeScaleQE::HttpClient] http_client Instance of http client
      def initialize(http_client, service = nil)
        super(http_client, entity_name: 'service_plan', collection_name: 'plans')
        @service = service
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service.entity_id}/service_plans"
      end

      # @api public
      # Lists all service plans
      #
      # @return [Array<ServicePlan>] List of ServicePlans
      def list_all
        super('/admin/api/service_plans')
      end
    end
  end
end
