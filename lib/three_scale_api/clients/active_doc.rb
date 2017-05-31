# frozen_string_literal: true

require 'three_scale_api/clients/default'

module ThreeScaleApi
  module Clients
    # Active doc resource manager wrapper for the active doc entity received by the REST API
    class ActiveDocManager < DefaultManager
      # @api public
      # Creates instance of the Active doc resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'api_doc', collection_name: 'api_docs')
        @resource_instance = ActiveDoc
      end

      # @api public
      # Gets active doc by ID
      #
      # @param [Fixnum] id Active doc id
      # @return [ActiveDoc] Active doc resource instance
      def read(id)
        @log.info("Read #{resource_name}: #{id}")
        res = _list.find { |doc| doc['id'] == id }
        log_result res
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/active_docs'
      end
    end

    # Active doc resource wrapper for the active doc entity received by REST API
    class ActiveDoc < DefaultResource
      # Creates instance of the Active doc resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ActiveDocManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end
    end
  end
end
