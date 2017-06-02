# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    # Account user resource wrapper for account user received by REST API
    class AccountUser < DefaultResource
      include DefaultUserResource
      attr_accessor :account
      # @api public
      # Creates instance of the User resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountUserClient] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @account = manager.account
      end
    end
  end
end
