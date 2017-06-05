# frozen_string_literal: true

require 'three_scale_api/resources/default'
require 'three_scale_api/clients/account_user'
require 'three_scale_api/clients/application'

module ThreeScaleApi
  module Resources
    # Account Resource
    class Account < DefaultResource
      include DefaultStateResource
      # @api public
      # Creates instance of the Service resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [Clients::AccountClient] manager Instance of the manager
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
        manager_instance(:AccountUser)
      end

      # @api public
      # Gets  Application Manager
      #
      # @return [ApplicationClient] Account Users Manager
      def applications
        manager_instance(:Application)
      end
    end
  end
end
