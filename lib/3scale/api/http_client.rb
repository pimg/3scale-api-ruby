require 'json'

module ThreeScale
  module API
    class HttpClient
      attr_reader :admin_domain, :provider_key, :format

      def initialize(admin_domain: , provider_key: , format: :json, secure: true)
        @admin_domain = admin_domain.freeze
        @provider_key = provider_key.freeze
        @http = Net::HTTP.new(@admin_domain, secure ? 443 : 80)
        @http.use_ssl = secure
        @http.set_debug_output($stdout)
        @format = format
      end

      def get(path)
        parse @http.get("#{path}.#{format}", headers)
      end

      def headers
        {
            'Accept' => "application/#{format}",
            'Authorization' =>  'Basic ' + [":#{@provider_key}"].pack('m').delete("\r\n")
        }
      end

      # @param [::Net::HTTPResponse] response
      def parse(response)
        parser.decode(response.body)
      end

      def parser
        case format
          when :json then JSONParser
          else "unknown format #{format}"
        end
      end


      module JSONParser
        module_function

        def decode(string)
          ::JSON.parse(string)
        end
      end
    end
  end
end
