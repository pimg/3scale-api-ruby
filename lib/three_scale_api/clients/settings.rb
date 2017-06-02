# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/clients/default'
require 'three_scale_api/resources/settings'


module ThreeScaleApi
  module Clients
    # Service resource manager wrapper for the service entity received by the REST API
    class SettingsClient < DefaultClient
      # @api public
      # Creates instance of the Service resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'settings')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/settings'
      end

      # @api public
      # Reads settings
      #
      # @return [Settings] Instance of the settings resource
      def read
        super
      end

      # @api public
      # Updates settings
      #
      # @param [Hash] attributes Settings attributes
      # @option attributes [Boolean] :useraccountarea_enabled Allow the user to edit their submitted
      #                                                      details, change passwords, etc
      # @option attributes [Boolean] :hide_service Used a default service plan
      # @option attributes [Boolean] :signups_enabled Developers are allowed sign up themselves.
      # @option attributes [Boolean] :account_approval_required Approval is required by you before
      #                                                        developer accounts are activated.
      # @option attributes [Boolean] :strong_passwords_enabled Require strong passwords
      #                                                       from your users:
      # @option attributes [Boolean] :public_search Enables public search on Developer Portal
      # @option attributes [Boolean] :account_plans_ui_visible Enables visibility of Account Plans
      # @option attributes [Boolean] :change_account_plan_permission Account Plans changing
      # @option attributes [Boolean] :service_plans_ui_visible Enables visibility of Service Plans
      # @option attributes [Boolean] :change_service_plan_permission Service Plans changing
      # @option attributes [Boolean] :end_user_plans_ui_visible Enables visibility of End User Plans
      def update(attributes)
        super(attributes, method: :patch)
      end
    end
  end
end
