# frozen_string_literal: true

require 'three_scale_api/http_client'
require 'three_scale_api/tools'
require 'three_scale_api/resources/service'
require 'three_scale_api/resources/account'
require 'three_scale_api/resources/account_plan'
require 'three_scale_api/resources/provider'
require 'three_scale_api/resources/webhook'
require 'three_scale_api/resources/active_doc'
require 'three_scale_api/resources/settings'

module ThreeScaleApi
  # Base class that is supposed to be used for communication with the REST API
  class Client
    attr_accessor :http_client

    # @api public
    # Initializes base client instance for manipulation with the REST API and resources
    #
    # @param [String] endpoint 3Scale admin pages url
    # @param [String] provider_key Provider access token
    # @param [String] log_level Log level ['debug', 'info', 'warning', 'error']
    # @param [Bool] verify_ssl Default value is true
    def initialize(endpoint:, provider_key:, log_level: 'info', verify_ssl: true)
      @http_client = HttpClient.new(endpoint: endpoint,
                                    provider_key: provider_key,
                                    verify_ssl: verify_ssl,
                                    log_level: log_level)
      @services_manager = nil
      @accounts_manager = nil
      @providers_manager = nil
      @webhooks_manager = nil
      @account_plans_manager = nil
      @active_docs_manager = nil
      @settings_manager = nil
    end

    # @api public
    # Gets services manager instance
    #
    # @return [ThreeScaleApi::Resources::ServiceManager] Service manager instance
    def services
      @services_manager ||= ThreeScaleApi::Resources::ServiceManager.new(@http_client)
    end

    # @api public
    # Gets accounts manager instance
    #
    # @return [ThreeScaleApi::Resources::AccountManager] Account manager instance
    def accounts
      @accounts_manager ||= ThreeScaleApi::Resources::AccountManager.new(@http_client)
    end

    # @api public
    # Gets providers manager instance
    #
    # @return [ThreeScaleApi::Resources::ProviderManager] Provider manager instance
    def providers
      @providers_manager ||= ThreeScaleApi::Resources::ProviderManager.new(@http_client)
    end

    # @api public
    # Gets account plans manager instance
    #
    # @return [ThreeScaleApi::Resources::AccountPlanManager] Account plans manager instance
    def account_plans
      @account_plans_manager ||= ThreeScaleApi::Resources::AccountPlanManager.new(@http_client)
    end

    # @api public
    # Gets active docs manager instance
    #
    # @return [ThreeScaleApi::Resources::ActiveDocManager] active docs manager instance
    def active_docs
      @active_docs_manager ||= ThreeScaleApi::Resources::ActiveDocManager.new(@http_client)
    end

    # @api public
    # Gets webhooks manager instance
    #
    # @return [ThreeScaleApi::Resources::WebHookManager] WebHooks manager instance
    def webhooks
      @webhooks_manager ||= ThreeScaleApi::Resources::WebHookManager.new(@http_client)
    end

    # @api public
    # Gets settings manager instance
    #
    # @return [ThreeScaleApi::Resources::SettingsManager] Settings manager instance
    def settings
      @settings_manager ||= ThreeScaleApi::Resources::SettingsManager.new(@http_client)
    end
  end
end
