# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/resources/default'
require 'three_scale_api/clients/proxy'
require 'three_scale_api/clients/metric'
require 'three_scale_api/clients/plans'
require 'three_scale_api/clients/mapping_rule'

module ThreeScaleApi
  module Resources
    # Service resource wrapper for the service entity received by REST API
    class Service < DefaultResource
      # @api public
      # Creates instance of the Service resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ServiceClient] manager Instance of the service manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end

      # @api public
      # Gets the service plans manager that has bind this service resource
      #
      # @return [ServicePlansManager] Instance of the service plans manager
      def service_plans
        manager_instance(:ServicePlan)
      end

      # @api public
      # Gets the proxy manager that has bind this service resource
      #
      # @return [ProxyClient] Instance of the proxy manager
      def proxy
        manager_instance(:Proxy)
      end

      # @api public
      # Gets the metrics manager that has bind this service resource
      #
      # @return [MetricsManager] Instance of the metrics manager
      def metrics
        manager_instance(:Metric)
      end

      # @api public
      # Gets the mapping rules manager that has bind this service resource
      #
      # @return [MappingRulesManager] Instance of the mapping rules manager
      def mapping_rules(metric = nil)
        manager_instance(:MappingRule, metric: metric)
      end

      # @api public
      # Gets the application plans manager that has bind this service resource
      #
      # @return [ApplicationPlansManager] Instance of the app. plans manager
      def application_plans
        manager_instance(:ApplicationPlan)
      end
    end
  end
end
