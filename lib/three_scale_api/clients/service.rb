# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/clients/default'
require 'three_scale_api/clients/proxy'
require 'three_scale_api/clients/metric'
require 'three_scale_api/clients/plans'
require 'three_scale_api/clients/mapping_rule'
require 'three_scale_api/clients/plans'
require 'three_scale_api/resources/service'

module ThreeScaleApi
  module Clients
    # Service resource manager wrapper for the service entity received by the REST API
    class ServiceClient < DefaultClient
      # @api public
      # Creates instance of the Service resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'service')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/services'
      end
    end
  end
end
