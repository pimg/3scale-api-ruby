# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/webhook'


module ThreeScaleApi
  module Clients
    # WebHook resource manager wrapper for the WebHook entity received by the REST API
    class WebHookClient < DefaultClient
      attr_accessor :service

      # @api public
      # Creates instance of the WebHook resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'webhook', collection_name: 'webhooks')
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat '/webhooks'
      end

      # @api public
      # Updates Webhooks
      #
      # @param [Hash] attributes Attributes that will be updated
      # @option attributes [String] :url URL that will be notified about all the events
      # @option attributes [Boolean] :active Activate/Disable WebHooks
      # @option attributes [Boolean] :provider_actions Dashboard actions fire web hooks.
      #                                               If false, only user actions in the portal
      #                                               triggers events.
      # @option attributes [Boolean] :account_created_on
      # @option attributes [Boolean] :account_updated_on
      # @option attributes [Boolean] :account_deleted_on
      # @option attributes [Boolean] :user_created_on
      # @option attributes [Boolean] :user_updated_on
      # @option attributes [Boolean] :user_deleted_on
      # @option attributes [Boolean] :application_created_on
      # @option attributes [Boolean] :application_updated_on
      # @option attributes [Boolean] :application_deleted_on
      # @option attributes [Boolean] :account_plan_changed_on
      # @option attributes [Boolean] :application_plan_changed_on
      # @option attributes [Boolean] :application_user_key_updated_on
      # @option attributes [Boolean] :application_key_created_on
      # @option attributes [Boolean] :application_key_deleted_on
      # @option attributes [Boolean] :application_suspended_on
      # @option attributes [Boolean] :application_key_updated_on
      # @return [Hash] Webhook
      def update(attributes)
        super(attributes, method: :patch)
      end

      # @api public
      # Reads webhooks configuration
      #
      # @return [WebHook] Webhook resource
      def read
        @log.info('Read webhook')
        response = http_client.patch(base_path, body: {})
        log_result resource_instance(response)
      end
    end
  end
end
