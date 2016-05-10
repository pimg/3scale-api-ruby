require 'securerandom'

RSpec.describe 'Account API', type: :integration do

  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }

  subject(:client) { ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key) }

  context '#signup' do
    let(:name) { SecureRandom.hex(14) }
    let(:email) { "#{name}@example.com" }

    subject(:create) { client.signup(name: name, email: email, password: name,
                                     billing_address_city: 'Barcelona',
                                     'billing_address_country' => 'Spain') }

    it do
      expect(create).to include('org_name' => name)
      expect(create['billing_address']).to include('company' => name, 'city' => 'Barcelona', 'country' => 'Spain')
    end
  end
end
