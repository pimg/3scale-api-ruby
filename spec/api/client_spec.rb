RSpec.describe ThreeScale::API::Client do
  let(:http_client) { double(ThreeScale::API::HttpClient) }

  it { is_expected.to be }

  subject(:client) { described_class.new(http_client) }

  context '#show_service' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42').and_return('service' => {})
      expect(client.show_service(42)).to eq({})
    end
  end

  context '#list_services' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services').and_return('services' => [])
      expect(client.list_services).to eq([])
    end
  end

  context '#create_service' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services', body: { service: {}})
                                 .and_return('service' => {})
      expect(client.create_service({})).to eq({})
    end
  end

  context '#list_metrics' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/metrics').and_return('metrics' => [])
      expect(client.list_metrics(42)).to eq([])
    end
  end

  context '#create_metric' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/metrics', body: { metric: {}})
                                 .and_return('metric' => {})
      expect(client.create_metric(42, {})).to eq({})
    end
  end
end
