module ThreeScale
  module API
    class Client

      attr_reader :http_client

      # @param [ThreeScale::API::HttpClient] http_client

      def initialize(http_client)
        @http_client = http_client
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] id Service ID
      def show_service(id)
        response = http_client.get("/admin/api/services/#{id}")
        extract(entity: 'service', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      def list_services
        response = http_client.get('/admin/api/services')
        extract(collection: 'services', entity: 'service', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_applications(service_id: nil)
        params = service_id ? { service_id: service_id } : nil
        response = http_client.get("/admin/api/applications", params: params)
        extract(collection: 'applications', entity: 'application', from: response)
      end

      # @api public
      # @return [Hash] an Account
      # @param [String] name Account Name
      # @param [String] email User Email
      # @param [String] password User Password
      # @param [Hash] attributes User and Account Attributes
      # @option attributes [String] :account_plan_id Account Plan ID
      # @option attributes [String] :service_plan_id Service Plan ID
      # @option attributes [String] :application_plan_id Application Plan ID
      # @option attributes [String] :username User Name. Defaults to User Email.
      def signup(attributes = {}, name: , email: , password: , **rest)
        body = { org_name: name,
                 username: email,
                 email: email,
                 password: password }.merge(attributes).merge(rest)
        response = http_client.post('/admin/api/signup', body: body)
        extract(entity: 'account', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Hash] attributes Service Attributes
      # @option attributes [String] :name Service Name
      def create_service(attributes)
        response = http_client.post('/admin/api/services', body: { service: attributes })
        extract(entity: 'service', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def show_proxy(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy")
        extract(entity: 'proxy', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      def update_proxy(service_id, attributes)
        response = http_client.patch("/admin/api/services/#{service_id}/proxy",
                                     body: { proxy: attributes })
        extract(entity: 'proxy', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_mapping_rules(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules")
        extract(entity: 'mapping_rule', collection: 'mapping_rules', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def show_mapping_rule(service_id, id)
        response = http_client.get("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def create_mapping_rule(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/proxy/mapping_rules",
                                   body: { mapping_rule: attributes })
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      def delete_mapping_rule(service_id, id)
        http_client.delete("/admin/api/services/#{service_id}/proxy/mapping_rules/#{id}")
        true
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] id Mapping Rule ID
      # @param [Hash] attributes Mapping Rule Attributes
      # @option attributes [String] :http_method HTTP Method
      # @option attributes [String] :pattern Pattern
      # @option attributes [Fixnum] :delta Increase the metric by delta.
      # @option attributes [Fixnum] :metric_id Metric ID
      def update_mapping_rule(service_id, id, attributes)
        response = http_client.patch("/admin/api/services/#{service_id}/mapping_rules/#{id}",
                                   body: { mapping_rule: attributes })
        extract(entity: 'mapping_rule', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_metrics(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics")
        extract(collection: 'metrics', entity: 'metric', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Metric Name
      def create_metric(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics", body: { metric: attributes })
        extract(entity: 'metric', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      def list_methods(service_id, metric_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods")
        extract(collection: 'methods', entity: 'method', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Method Name
      def create_method(service_id, metric_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods",
                                   body: { metric: attributes })
        extract(entity: 'method', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] service_id Service ID
      def list_service_application_plans(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/application_plans")

        extract(collection: 'plans', entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] service_id Service ID
      # @param [Hash] attributes Metric Attributes
      # @option attributes [String] :name Application Plan Name
      def create_application_plan(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/application_plans",
                                    body: { application_plan: attributes })
        extract(entity: 'application_plan', from: response)
      end

      # @api public
      # @return [Array<Hash>]
      # @param [Fixnum] application_plan_id Application Plan ID
      def list_application_plan_limits(application_plan_id)
        response = http_client.get("/admin/api/application_plans/#{application_plan_id}/limits")

        extract(collection: 'limits', entity: 'limit', from: response)
      end

      # @api public
      # @return [Hash]
      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Hash] attributes Metric Attributes
      # @param [Fixnum] metric_id Metric ID
      # @option attributes [String] :period Usage Limit period
      # @option attributes [String] :value Usage Limit value
      def create_application_plan_limit(application_plan_id, metric_id, attributes)
        response = http_client.post("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits",
                                    body: { usage_limit: attributes })
        extract(entity: 'limit', from: response)
      end

      # @param [Fixnum] application_plan_id Application Plan ID
      # @param [Fixnum] metric_id Metric ID
      # @param [Fixnum] limit_id Usage Limit ID
      def delete_application_plan_limit(application_plan_id, metric_id, limit_id)
        http_client.delete("/admin/api/application_plans/#{application_plan_id}/metrics/#{metric_id}/limits/#{limit_id}")
        true
      end

      protected

      def extract(collection: nil, entity: , from: )
        if collection
          from = from.fetch(collection)
        end

        case from
          when Array then from.map { |e| e.fetch(entity) }
          when Hash then from.fetch(entity) { from }
          when nil then nil # raise exception?
          else
            raise "unknown #{from}"
        end

      end
    end
  end
end
