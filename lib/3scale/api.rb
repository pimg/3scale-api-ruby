require '3scale/api/version'

module ThreeScale
  module API
    autoload :Client, '3scale/api/client'
    autoload :HttpClient, '3scale/api/http_client'

    def self.new(endpoint:, provider_key: nil, access_token: nil)
      raise ArgumentError.new("access_token or provider_key should be provided") unless provider_key || access_token
      http_client = HttpClient.new(endpoint: endpoint,
                                   provider_key: provider_key,
                                   access_token: access_token)
      Client.new(http_client)
    end
  end
end
