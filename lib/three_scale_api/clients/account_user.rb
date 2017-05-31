# frozen_string_literal: true

require 'three_scale_api/clients/default_helpers'

module ThreeScaleApi
  module Clients
    # Account user resource manager wrapper for account user entity received by REST API
    class AccountUserManager < DefaultUserManager
      attr_accessor :account
      # @api public
      # Creates instance of the Account user resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Account] account Account entity
      def initialize(http_client, account)
        super(http_client)
        @resource_instance = AccountUser
        @account = account
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/accounts/#{@account['id']}/users"
      end
    end

    # Account user resource wrapper for account user received by REST API
    class AccountUser < DefaultUserResource
      attr_accessor :account
      # @api public
      # Creates instance of the User resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountUserManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @account = manager.account
      end
    end
  end
end
