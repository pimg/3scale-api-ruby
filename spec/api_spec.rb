require '3scale/api'

RSpec.describe ThreeScale::API do
  describe '#new' do

    context 'provider_key is provided' do

      subject!(:client) { described_class.new(endpoint: 'http://foo.3scale.net', provider_key: 'bar') }

      it { is_expected.to be_a(ThreeScale::API::Client) }
      it { expect(client.http_client).to be_a(ThreeScale::API::HttpClient) }
    end

    context 'access_token is provided' do
      
      subject!(:client) { described_class.new(endpoint: 'http://foo.3scale.net', access_token: 'bar') }

      it { is_expected.to be_a(ThreeScale::API::Client) }
      it { expect(client.http_client).to be_a(ThreeScale::API::HttpClient) }
    end

    context 'neither access_token nor provider_key are provided' do
      it 'raises an exception' do
        expect { described_class.new(endpoint: 'https://foo-admin.3scale.net') }.to raise_error(ArgumentError)
      end
    end
  end
end
