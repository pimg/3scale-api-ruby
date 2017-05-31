# frozen_string_literal: true

require 'three_scale_api/clients/default_helpers'
require 'three_scale_api/clients/account_user'
require 'three_scale_api/clients/application'

module ThreeScaleApi
  module Clients
    # Accounts resource manager wrapper for default entity received by REST API
    class AccountManager < DefaultStateManager
      # @api public
      # Creates instance of the Accounts resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'account', collection_name: 'accounts')
        @resource_instance = Account
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

    # Default resource wrapper for any entity received by REST API
    class Account < DefaultStateResource
      # @api public
      # Creates instance of the Service resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end

      # @api public
      # Sets plan for account
      #
      # @param [Fixnum] plan_id Plan ID
      def set_plan(plan_id)
        @manager.set_plan(@entity['id'], plan_id) if @manager.respond_to?(:set_plan)
      end

      # @api public
      # Approves account
      def approve
        set_state('approve')
      end

      # @api public
      # Reject account
      def reject
        set_state('reject')
      end

      # @api public
      # Set pending for account
      def pending
        set_state('pending')
      end

      # @api public
      # Gets Account Users Manager
      #
      # @return [AccountUsersManager] Account Users Manager
      def users
        manager_instance(AccountUserManager)
      end

      # @api public
      # Gets  Application Manager
      #
      # @return [ApplicationManager] Account Users Manager
      def applications
        manager_instance(ApplicationManager)
      end
    end
  end
end
