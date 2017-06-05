# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources

    # Application plan resource wrapper for an application entity received by the REST API
    class ApplicationPlan < DefaultResource
      include DefaultPlanResource
      attr_accessor :service

      # @api public
      # Construct the proxy resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ThreeScaleApi::Clients::DefaultClient] manager Instance of test client
      # @param [Hash] entity Entity Hash from API client of the proxy
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end

      # @api public
      # Gets instance of the limits manager
      #
      # @return [ApplicationPlanLimitClient] Application plan limit manager
      # @param [Metric] metric Metric resource
      def limits(metric = nil)
        manager_instance(:ApplicationPlanLimit, metric: metric)
      end
    end

    # Account resource wrapper for account entity received by REST API
    class AccountPlan < DefaultResource
      include DefaultPlanResource
      # Creates instance of the Account resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountPlanClient] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end

    # Service plan resource wrapper for proxy entity received by REST API
    class ServicePlan < DefaultResource
      include DefaultPlanResource
      attr_accessor :service

      # @api public
      # Construct the proxy resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of test client
      # @param [ServicePlanClient] manager Instance of the manager
      # @param [Hash] entity Entity Hash from API client of the proxy
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @service = manager.service
      end
    end
  end
end
