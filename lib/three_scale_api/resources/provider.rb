# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/resources/default_helpers'

module ThreeScaleApi
  module Resources
    # Provider resource manager wrapper for the provider entity received by the REST API
    class ProviderManager < DefaultUserManager
      # @api public
      # Creates instance of the Provider resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client)
        @resource_instance = Provider
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/users'
      end
    end

    # Provider resource wrapper for the provider entity received by REST API
    class Provider < DefaultUserResource
      # @api public
      # Creates instance of the Provider resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ProviderManager] manager Instance of the provider manager
      # @param [Hash] entity Provider Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end
  end
end
