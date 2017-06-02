# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources

    # Provider resource wrapper for the provider entity received by REST API
    class Provider < DefaultResource
      include DefaultUserResource
      # @api public
      # Creates instance of the Provider resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ProviderClient] manager Instance of the provider manager
      # @param [Hash] entity Provider Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end
  end
end
