# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    # Active doc resource wrapper for the active doc entity received by REST API
    class ActiveDoc < DefaultResource
      # Creates instance of the Active doc resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ActiveDocClient] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end
  end
end
