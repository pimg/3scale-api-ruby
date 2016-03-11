module ThreeScale
  module API
    class Client

      attr_reader :http_client

      # @param [ThreeScale::API::HttpClient] http_client

      def initialize(http_client)
        @http_client = http_client
      end

      def show_service(id)
        response = http_client.get("/admin/api/services/#{id}")
        extract(entity: 'service', from: response)
      end

      def list_services
        response = http_client.get('/admin/api/services')
        extract(collection: 'services', entity: 'service', from: response)
      end

      def create_service(attributes)
        response = http_client.post('/admin/api/services', body: { service: attributes })
        extract(entity: 'service', from: response)
      end

      def list_metrics(service_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics")
        extract(collection: 'metrics', entity: 'metric', from: response)
      end

      def create_metric(service_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics", body: { metric: attributes })
        extract(entity: 'metric', from: response)
      end

      def list_methods(service_id, metric_id)
        response = http_client.get("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods")
        extract(collection: 'methods', entity: 'method', from: response)
      end

      def create_method(service_id, metric_id, attributes)
        response = http_client.post("/admin/api/services/#{service_id}/metrics/#{metric_id}/methods",
                                   body: { metric: attributes })
        extract(entity: 'method', from: response)
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
