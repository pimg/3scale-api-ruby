# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/account_user'


module ThreeScaleApi
  module Clients
    # Account user resource manager wrapper for account user entity received by REST API
    class AccountUserClient < DefaultClient
      include DefaultUserClient

      attr_accessor :account
      # @api public
      # Creates instance of the Account user resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Account] account Account entity
      def initialize(http_client, account)
        super(http_client, entity_name: 'user')
        @account = account
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/accounts/#{@account['id']}/users"
      end
    end
  end
end
