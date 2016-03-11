RSpec.describe ThreeScale::API::HttpClient do
  describe '#initialize' do
    subject(:client) { described_class.new(endpoint: 'https://foo-admin.3scale.net',
                                           provider_key: 'some-key') }

    it { is_expected.to be }

    it { expect(client.admin_domain).to eq('foo-admin.3scale.net') }
    it { expect(client.provider_key).to eq('some-key') }
  end

  let(:admin_domain) { 'foo-admin.3scale.net' }
  let(:provider_key) { 'some-key' }

  subject(:client) { described_class.new(endpoint: "https://#{admin_domain}", provider_key: provider_key) }

  describe '#get' do
    let!(:stub) {
      stub_request(:get,  "https://:#{provider_key}@#{admin_domain}/foo.json")
        .and_return(body: '{"foo":"bar"}')
    }

    subject { client.get('/foo') }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end
end
