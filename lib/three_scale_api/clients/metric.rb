# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'
require 'three_scale_api/resources/metric'


module ThreeScaleApi
  module Clients
    # Metric resource manager wrapper for the metric entity received by REST API
    class MetricClient < DefaultClient
      attr_accessor :service

      # @api public
      # Creates instance of the Proxy resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client, service)
        super(http_client, entity_name: 'metric', collection_name: 'metrics')
        @service = service
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service['id']}/metrics"
      end
    end
  end
end
