# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/account'
require 'three_scale_api/clients/account_user'
require 'three_scale_api/clients/application'

module ThreeScaleApi
  module Clients
    # Accounts resource manager wrapper for default entity received by REST API
    class AccountClient < DefaultClient
      include DefaultStateClient
      # @api public
      # Creates instance of the Accounts resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'account', collection_name: 'accounts')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/accounts'
      end

      # @api public
      # Creates developer account (Same way as used in Developer portal)
      # Will also create default user with username
      #
      # @param [Hash] attributes Attributes
      # @option attributes [String] :email User Email
      # @option attributes [String] :org_name Account name
      # @option attributes [String] :username User name
      # @option attributes [String] :password User Password
      # @option attributes [String] :account_plan_id Account Plan ID
      # @option attributes [String] :service_plan_id Service Plan ID
      # @option attributes [String] :application_plan_id Application Plan ID
      def sign_up(attributes)
        @log.info("Sign UP: #{attributes}")
        response = http_client.post('/admin/api/signup', body: attributes)
        log_result resource_instance(response)
      end

      # @api public
      # Creates developer
      #
      # Attributes same as for sign_up
      def create(attributes)
        sign_up(attributes)
      end

      # @api public
      # Sets default plan for dev. account
      #
      # @param [Fixnum] id Account ID
      # @param [Fixnum] plan_id Plan id
      def set_plan(id, plan_id)
        @log.info("Set #{resource_name}  default (id: #{id}) ")
        body = { plan_id: plan_id }
        response = http_client.put("#{base_path}/#{id}/change_plan", body: body)
        log_result resource_instance(response)
      end

      # @api public
      # Approves account
      #
      # @param [Fixnum] id Account ID
      def approve(id)
        set_state(id, 'approve')
      end

      # @api public
      # Rejects account
      #
      # @param [Fixnum] id Account ID
      def reject(id)
        set_state(id, 'reject')
      end

      # @api public
      # Set pending
      #
      # @param [Fixnum] id Account ID
      def pending(id)
        set_state(id, 'make_pending')
      end
    end
  end
end
