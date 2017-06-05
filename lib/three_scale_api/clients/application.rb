# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/clients/application_key'
require 'three_scale_api/resources/application'



module ThreeScaleApi
  module Clients
    # Application resource manager wrapper for an application entity received by the REST API
    class ApplicationClient < DefaultClient
      include DefaultStateClient
      attr_accessor :account
      # @api public
      # Creates instance of the Service resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      # @param [Account] account Account entity
      def initialize(http_client, account)
        super(http_client, entity_name: 'application')
        @account = account
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/accounts/#{@account.entity_id}/applications"
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
  end
end
