# frozen_string_literal: true

require 'three_scale_api/clients/default'
require 'three_scale_api/clients/application_plan_limit'
require 'three_scale_api/clients/method'
require 'three_scale_api/resources/mapping_rule'


module ThreeScaleApi
  module Clients
    # Mapping rules resource manager wrapper for the mapping rule entity received by REST API
    class MappingRuleClient < DefaultClient
      attr_accessor :service, :metric

      # @api public
      # Creates instance of the mapping rules resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client, service, metric: nil)
        super(http_client, entity_name: 'mapping_rule', collection_name: 'mapping_rules')
        @service = service
        @metric = metric
      end

      # @api public
      # Binds metric
      #
      # @param [Metric] metric Service metric
      def set_metric(metric)
        @metric = metric
      end

      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        super.concat "/services/#{@service['id']}/proxy/mapping_rules"
      end

      # @api public
      # Creates new mapping rule
      #
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def create(attributes)
        attributes[:metric_id] ||= @metric['id']
        super(attributes)
      end

      # @api public
      # Updates mapping rule
      #
      # @param [Fixnum] id Mapping rule id
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def update(attributes, id: nil)
        attributes[:metric_id] ||= @metric['id']
        super(attributes, id: id)
      end
    end
  end
end
