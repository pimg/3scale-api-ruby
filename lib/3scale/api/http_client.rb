require 'json'

module ThreeScale
  module API
    class HttpClient
      attr_reader :endpoint, :admin_domain, :provider_key, :headers, :format

      def initialize(endpoint: , provider_key: , format: :json)
        @endpoint = URI(endpoint).freeze
        @admin_domain = @endpoint.host.freeze
        @provider_key = provider_key.freeze
        @http = Net::HTTP.new(admin_domain, @endpoint.port)
        @http.use_ssl = @endpoint.is_a?(URI::HTTPS)

        @headers = {
            'Accept' => "application/#{format}",
            'Content-Type' => "application/#{format}",
            'Authorization' =>  'Basic ' + [":#{@provider_key}"].pack('m').delete("\r\n")
        }

        if debug?
          @http.set_debug_output($stdout)
          @headers['Accept-Encoding'] = 'identity'
        end

        @headers.freeze

        @format = format
      end

      def get(path)
        parse @http.get("#{path}.#{format}", headers)
      end

      def post(path, body: )
        parse @http.post("#{path}.#{format}", serialize(body), headers)
      end

      # @param [::Net::HTTPResponse] response
      def parse(response)
        parser.decode(response.body)
      end

      def serialize(body)
        case body
          when String then body
          else parser.encode(body)
        end
      end

      def parser
        case format
          when :json then JSONParser
          else "unknown format #{format}"
        end
      end

      protected

      def debug?
        ENV.fetch('3SCALE_DEBUG', '0') == '1'
      end

      module JSONParser
        module_function

        def decode(string)
          ::JSON.parse(string)
        end

        def encode(query)
          ::JSON.generate(query)
        end
      end
    end
  end
end
