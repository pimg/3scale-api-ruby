# frozen_string_literal: true

require 'json'
require 'uri'
require 'net/http'
require 'three_scale_api/tools'
require 'openssl'

module ThreeScaleApi
  # Http Client
  class HttpClient
    attr_reader :endpoint,
                :admin_domain,
                :provider_key,
                :headers,
                :format,
                :log,
                :logger_factory

    # @api public
    # Initializes HttpClient
    #
    # @param [String] endpoint 3Scale admin endpoint
    # @param [String] provider_key Provider key
    # @param [String] format Which format
    # @param [Boolean] verify_ssl Verify ssl certificate (default is 'true')
    # @param [String] log_level Log level ['debug', 'info', 'warning', 'error']
    #     There is special log_level that is called 'trace', for inspecting NET::HTTP communication
    def initialize(endpoint:,
                   provider_key:,
                   format: :json,
                   verify_ssl: true,
                   log_level: 'debug')
      @endpoint = URI(endpoint)
      @log_level = log_level
      @admin_domain = @endpoint.host
      @provider_key = provider_key
      @logger_factory = ThreeScaleApi::Tools::LoggingFactory.new(log_level: log_level)
      @log = @logger_factory.get_instance(name: 'HttpClient')
      @format = format
      @verify_ssl = verify_ssl
      @headers = create_headers
      @http = nil
    end

    # @api public
    # Gets instance of the NET::HTTP client
    #
    # @return [Net::HTTP]
    def http
      @http ||= initialize_http_client
    end

    # @api public
    # Creates GET request to specified path
    #
    # @param [String] path Relative request path to endpoint
    # @param [Hash] params Optional parameters for the request
    def get(path, params: nil)
      @log.debug("[GET] #{path}")
      parse http.get(format_path_n_query(path, params), headers)
    end

    # @api public
    # Creates PATCH request to specified path
    #
    # @param [String] path Relative request path to endpoint
    # @param [Hash] body Request's body
    # @param [Hash] params Optional parameters for the request
    def patch(path, body:, params: nil)
      @log.debug("[PATCH] #{path}: #{body}")
      parse http.patch(format_path_n_query(path, params), serialize(body), headers)
    end

    # @api public
    # Creates POST request to specified path
    #
    # @param [String] path Relative request path to endpoint
    # @param [Hash] body Request's body
    # @param [Hash] params Optional parameters for the request
    def post(path, body:, params: nil)
      @log.debug("[POST] #{path}: #{body}")
      parse http.post(format_path_n_query(path, params), serialize(body), headers)
    end

    # @api public
    # Creates PUT request to specified path
    #
    # @param [String] path Relative request path to endpoint
    # @param [Hash] body Request's body
    # @param [Hash] params Optional parameters for the request
    def put(path, body: nil, params: nil)
      @log.debug("[PUT] #{path}: #{body}")
      parse http.put(format_path_n_query(path, params), serialize(body), headers)
    end

    # @api public
    # Creates DELETE request to specified path
    #
    # @param [String] path Relative request path to endpoint
    # @param [Hash] params Optional parameters for the request
    def delete(path, params: nil)
      @log.debug("[DELETE] #{path}")
      parse http.delete(format_path_n_query(path, params), headers)
    end

    # @api public
    # Parses entity params from the response and checks status code
    #
    # @param [::Net::HTTPResponse] response Response received using some of the request methods
    # @return [Hash] Entity params
    def parse(response)
      case response
      when Net::HTTPUnprocessableEntity, Net::HTTPSuccess then parser.decode(response.body)
      when Net::HTTPForbidden then forbidden!(response)
      when Net::HTTPNotFound then not_found!(response)
      else "Can't handle #{response.inspect}"
      end
    end

    # @api public
    # Custom exception class that is thrown when the resource is not found
    class NotFoundError < StandardError; end

    # Not found - wrapper to throw NotFoundError
    #
    # @param [::Net::HTTPResponse] response Response received using some of the request methods
    # @raise [NotFoundError] Required resource hasn't been found
    def not_found!(response)
      raise NotFoundError, response
    end

    # @api public
    # Custom exception class that is thrown when the access to resource is forbidden
    class ForbiddenError < StandardError; end

    # Forbidden access - Wrapper to throw ForbiddenError
    #
    # @param [::Net::HTTPResponse] response Response received using some of the request methods
    # @raise [ForbiddenError] Access to required resource has been denied
    def forbidden!(response)
      raise ForbiddenError, response
    end

    # Takes request body and serializes it to JSON
    #
    # @param [String, Hash] body Body is serialized to JSON if it is not a string
    # @return [String] Serialized body
    def serialize(body)
      case body
      when nil then nil
      when String then body
      else parser.encode(body)
      end
    end

    # Gets parser
    #
    # Currently only supported parser is JSONParser
    def parser
      case @format
      when :json then JSONParser
      else "unknown format #{format}"
      end
    end

    protected

    def trace_net_http?
      @log_level == 'trace'
    end

    # Creates headers
    #
    # @return [Hash] Generated headers
    def create_headers
      headers = {
        'Accept': "application/#{@format}",
        'Content-Type': "application/#{@format}",
        'Authorization': 'Basic ' + [":#{@provider_key}"].pack('m').delete("\r\n"),
      }
      headers['Accept-Encoding'] = 'identity' if trace_net_http?
      headers.freeze
    end

    # Creates http client
    #
    # @return [Net::HTTP] Http client instance
    def initialize_http_client
      http_client = Net::HTTP.new(admin_domain, @endpoint.port)
      http_client.set_debug_output($stdout) if trace_net_http?
      http_client.use_ssl = @endpoint.is_a?(URI::HTTPS)
      http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @verify_ssl
      http_client
    end

    # Helper to create a string representing a path plus a query string
    def format_path_n_query(path, params)
      path = "#{path}.#{@format}"
      path += "?#{URI.encode_www_form(params)}" unless params.nil?
      path
    end

    # Json parser module
    module JSONParser
      module_function

      # @api public
      # Decodes JSON string to Hash
      #
      # @param [String] string String JSON
      # @return [Hash] Parsed JSON to Hash
      def decode(string)
        case string
        when nil, ' ', '' then nil
        else ::JSON.parse(string)
        end
      end

      # @api public
      # Creates JSON from query
      #
      # @param [Hash] query Hash query to be encoded
      # @return [String] JSON String
      def encode(query)
        ::JSON.generate(query)
      end
    end
  end
end
