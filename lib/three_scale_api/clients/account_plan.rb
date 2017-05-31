# frozen_string_literal: true

require 'three_scale_api/clients/default_helpers'

module ThreeScaleApi
  module Clients
    # Account plan resource manager wrapper for account plan entity received by REST API
    class AccountPlanManager < DefaultPlanManager
      # @api public
      # Creates instance of the Account resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'account_plan', collection_name: 'plans')
        @resource_instance = AccountPlan
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

    # Account resource wrapper for account entity received by REST API
    class AccountPlan < DefaultPlanResource
      # Creates instance of the Account resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountPlanManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end
  end
end
