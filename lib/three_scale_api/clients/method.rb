# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/resources/method'


module ThreeScaleApi
  module Clients
    # Method resource manager wrapper for the method entity received by REST API
    class MethodClient < DefaultClient
      attr_accessor :service, :metric

      # @api public
      # Creates instance of the Method resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Metric] metric Instance of the metric resource
      def initialize(http_client, metric)
        super(http_client, entity_name: 'method', collection_name: 'methods')
        @service = metric.service
        @metric = metric
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service['id']}/metrics/#{@metric['id']}/methods"
      end
    end
  end
end
