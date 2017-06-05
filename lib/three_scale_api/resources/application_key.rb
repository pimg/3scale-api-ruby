# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    # Application key resource wrapper for a application key entity received by the REST API
    class ApplicationKey < DefaultResource
      attr_accessor :account, :application
      # @api public
      # Creates instance of the Application key resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ApplicationKeyClient] manager Instance of the manager
      # @param [Hash] entity Application key Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @account = manager.account
        @application = manager.application
      end

      # @api public
      # Deletes key resource
      def delete
        @manager.delete(entity['value']) if @manager.respond_to?(:delete)
      end
    end
  end
end
