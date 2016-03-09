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

      protected

      def extract(collection: nil, entity: , from: )
        if collection
          from = from.fetch(collection)
        end

        case from
          when Array then from.map { |e| e.fetch(entity) }
          when Hash then from.fetch(entity)
          else
            raise "unknown #{from}"
        end

      end
    end
  end
end
