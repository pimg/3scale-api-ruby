# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/resources/proxy'

module ThreeScaleApi
  module Clients
    # Proxy resource manager wrapper for the proxy entity received by the REST API
    class ProxyClient < DefaultClient
      attr_accessor :service
      # @api public
      # Creates instance of the Proxy resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client, service)
        super(http_client, entity_name: 'proxy', collection_name: 'proxies')
        @service = service
      end

      # @api public
      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service.entity_id}/proxy"
      end

      # @api public
      # Promotes proxy configuration from one env to another
      #
      # @param [Fixnum] version Configuration ID
      # @param [String] from From which environment
      # @param [String] to To which environment
      # @return [Proxy] Instance of the proxy resource
      def promote(version: 1, from: 'sandbox', to: 'production')
        log.info "Promote #{resource_name} [#{version}] from \"#{from}\" to \"#{to}\""

        path = "#{base_path}/configs/#{from}/#{version}/promote"
        response = @http_client.post(path, params: { to: to }, body: {})
        log_result resource_instance(response)
      end

      # @api public
      # Gets list of the proxy configs for spec. environment
      #
      # @return [Array<Proxy>] Array of the instances of the proxy resource
      # @param [String] env Environment name
      def config_list(env: 'sandbox')
        log.info "Lists #{resource_name} Configs for \"#{env}\""
        response = http_client.get("#{base_path}/configs/#{env}")
        log_result resource_instance(response)
      end

      # @api public
      # Reads configuration of the provided environment by provided ID
      #
      # @param [Fixnum] id Id of the configuration
      # @param [String] env Environment name
      # @return [Proxy] Instance of the proxy resource
      def config_read(id: 1, env: 'sandbox')
        log.info("#{resource_name} config [#{id}] for \"#{env}\"")
        response = http_client.get("#{base_path}/configs/#{env}/#{id}")
        log_result resource_instance(response)
      end

      # @api public
      # Gets latest configuration of specified environment
      #
      # @param [String] env Environment name
      # @return [Proxy] Instance of the proxy resource
      def latest(env: 'sandbox')
        log.info("Latest #{resource_name} config for: #{env}")
        response = http_client.get("#{base_path}/configs/#{env}/latest")
        log_result resource_instance(response)
      end
    end
  end
end
