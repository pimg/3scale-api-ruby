require '3scale/api/version'

module ThreeScale
  module API
    autoload :Client, '3scale/api/client'
    autoload :HttpClient, '3scale/api/http_client'

    def self.new(admin_domain:, provider_key:)
      http_client = HttpClient.new(admin_domain: admin_domain,
                                   provider_key: provider_key)
      Client.new(http_client)
    end
  end
end
