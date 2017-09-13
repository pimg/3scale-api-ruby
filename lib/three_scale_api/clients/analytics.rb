# frozen_string_literal: true

require 'three_scale_api/tools'

module ThreeScaleApi
  # Main module containing implementation of the resources and it's managers
  module Clients
    class AnalyticsClient
      # Gets manager name for logging purposes
      #
      # @return [String] Manager name
      def manager_name
        self.class.name.split('::').last
      end

      # @api public
      # Returns logger
      #
      # @return [Logger] returns logger
      def log
        @log ||= @http_client.logger_factory.get_instance(name: manager_name)
      end

      attr_accessor :http_client
      # @api public
      # Creates instance of the Default resource manager
      #
      # @param [ThreeScaleApi::HttpClient] http_client Instance of http client
      def initialize(http_client)
        @http_client = http_client
      end

      # List analytics by application for given metric
      #
      # @param [ThreeScaleApi::Resources::Application] app Application resource instance
      # @param [String] metric_name System name of metric to get data for.
      # @param [String] since Time range start.
      #   Format YYYY-MM-DD HH:MM:SS, '2012-02-22', '2012-02-22 23:49:00'.
      # @param [String] period 	Period combined with since time
      #   gives stats for the time range [since .. since + period].
      #   It is required if until time is not passed.
      # @option kwargs [String] until Time range end. Format YYYY-MM-DD HH:MM:SS
      # @option kwargs [String] granularity Granularity of results,
      #   each period has an associated granularity.
      # @option kwargs [String] timezone Time zone for calculations.
      # @option kwargs [Boolean] skip_change Skip period over period calculations (defaults to true)
      def list_by_application(app, metric_name:, since:, period: 'year', **kwargs)
        list_by_resource(
          app,
          resource_type: :applications,
          since: since,
          metric_name: metric_name,
          period: period,
          **kwargs
        )
      end

      # List analytics by service for given metric
      #
      # @param [ThreeScaleApi::Resources::Service] service Service resource instance
      # @param [String] metric_name System name of metric to get data for.
      # @param [String] since Time range start.
      #   Format YYYY-MM-DD HH:MM:SS, '2012-02-22', '2012-02-22 23:49:00'.
      # @param [String] period 	Period combined with since time
      #   gives stats for the time range [since .. since + period].
      #   It is required if until time is not passed.
      # @option kwargs [String] until Time range end. Format YYYY-MM-DD HH:MM:SS
      # @option kwargs [String] granularity Granularity of results,
      #   each period has an associated granularity.
      # @option kwargs [String] timezone Time zone for calculations.
      # @option kwargs [Boolean] skip_change Skip period over period calculations (defaults to true)
      def list_by_service(service, metric_name:, since:, period: 'year', **kwargs)
        list_by_resource(
          service,
          resource_type: :services,
          since: since,
          metric_name: metric_name,
          period: period,
          **kwargs
        )
      end

      # TODO implement method
      def list_top_apps

      end

      private

      # @param [ThreeScaleApi::Resources::DefaultResource] resource
      # @param [String] metric_name System name of metric to get data for.
      # @param [String] since Time range start. Format YYYY-MM-DD HH:MM:SS, '2012-02-22', '2012-02-22 23:49:00'.
      # @param [String] period 	Period combined with since time gives stats for the time range [since .. since + period].
      #   It is required if until time is not passed.
      # @option kwargs [String] until Time range end. Format YYYY-MM-DD HH:MM:SS
      # @option kwargs [String] granularity Granularity of results, each period has an associated granularity.
      # @option kwargs [String] timezone Time zone for calculations.
      # @option kwargs [Boolean] skip_change Skip period over period calculations (defaults to true).
      # @return [Hash] Analytics response, important attributes: 'total', 'values'
      def list_by_resource(resource, resource_type:, metric_name:, since:, period: 'year', **kwargs)
        log.info "List analytics by #{resource_type} (#{resource[:id]}) for metric (#{metric_name})"
        params = {
          metric_name: metric_name,
          since: since,
          period: period,
        }.merge(kwargs)
        full_path = "/stats/#{resource_type}/#{resource[:id]}/usage"
        response  = http_client.get(full_path, params: params)
        log.info "Response: #{response}"
        response
      end
    end
  end
end
