# frozen_string_literal: true

require 'three_scale_api/resources/default_helpers'
require 'three_scale_api/resources/application_key'

module ThreeScaleApi
  module Resources
    # Application resource manager wrapper for an application entity received by the REST API
    class ApplicationManager < DefaultStateManager
      attr_accessor :account
      # @api public
      # Creates instance of the Service resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Account] account Account entity
      def initialize(http_client, account)
        super(http_client, entity_name: 'application', collection_name: 'applications')
        @resource_instance = Application
        @account = account
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/accounts/#{account['id']}/applications"
      end

      # @api public
      # Lists all applications for each service
      #
      # @param [Fixnum] service_id Service ID
      # @return [Application] Application resource
      def list_all(service_id: nil)
        @log.info("List all #{resource_name}s")
        params = service_id ? { service_id: service_id } : nil
        response = http_client.get('/admin/api/applications', params: params)
        log_result resource_list(response)
      end

      # @api public
      # Creates an application
      #
      # @param [Hash] attributes Attributes for the application
      # @option attributes [String] :name Application Name
      # @option attributes [String] :description Application Description
      # @option attributes [String] :user_key Application User Key
      # @option attributes [String] :application_id Application App ID
      # @option attributes [String] :application_key Application App Key(s)
      # @option attributes [String] :redirect_url OAuth endpoint
      # @option attributes [Fixnum] :plan_id Application Plan ID
      # @return [Application] Instance of the application
      def create(attributes)
        super(attributes)
      end

      # @api public
      # Finds the application by specified attributes
      #
      # @param [Hash] params
      # @option params [Fixnum] :id Id of the application
      # @option params [String] :user_key User key for the application (if exists)
      # @option params [String] :application_id Application id for the application (if exists)
      # @option params [Fixnum] :service_id Service id that contains application
      # @return [Application] Application instance
      def find_by_params(**params)
        params = params.reject { |_, value| value.nil? }
        @log.info("Find #{resource_name} by #{params}")
        response = http_client.get('/admin/api/applications/find', params: params)
        log_result resource_instance(response)
      end

      # @api public
      # Accepts the application
      #
      # @param [Fixnum] id Application ID
      def accept(id)
        set_state(id, state: 'accept')
      end

      # @api public
      # Suspends the application
      #
      # @param [Fixnum] id Application ID
      def suspend(id)
        set_state(id, state: 'suspend')
      end

      # @api public
      # Resumes the application
      #
      # @param [Fixnum] id Application ID
      def resume(id)
        set_state(id, state: 'resume')
      end
    end

    # Application resource wrapper for an application received by the REST API
    class Application < DefaultStateResource
      attr_accessor :account
      # @api public
      # Creates instance of the Service resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [ApplicationManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
        @account = manager.account
      end

      # @api public
      # Applications keys manager instance
      #
      # @return [ApplicationKeysManager] Application keys manager instance
      def keys
        manager_instance(ApplicationKeyManager)
      end

      # @api public
      # Accept application
      def accept
        set_state('accept')
      end

      # @api public
      # Suspend application
      def suspend
        set_state('suspend')
      end

      # @api public
      # Resume application
      def resume
        set_state('resume')
      end
    end
  end
end
