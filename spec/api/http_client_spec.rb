RSpec.describe ThreeScale::API::HttpClient do
  describe '#initialize' do
    context 'provider_key is provided' do
      subject(:client) do
        described_class.new(endpoint: 'https://foo-admin.3scale.net',
                            provider_key: 'some-key')
      end

      it { is_expected.to be }

      it { expect(client.admin_domain).to eq('foo-admin.3scale.net') }
      it { expect(client.provider_key).to eq('some-key') }
    end

    context 'access_token is provided' do
      subject(:client) do
        described_class.new(endpoint: 'https://foo-admin.3scale.net',
                            access_token: 'some-token')
      end

      it { is_expected.to be }

      it { expect(client.admin_domain).to eq('foo-admin.3scale.net') }
      it { expect(client.access_token).to eq('some-token') }
    end

    context 'both provider_key and access_token are provided' do
      subject(:client) do
        described_class.new(endpoint: 'https://foo-admin.3scale.net',
                            access_token: 'some-token', provider_key: 'some-key')
      end

      it 'access_token takes precedence' do
        expect(client.headers['Authorization']).to include([":some-token"].pack('m').delete("\r\n"))
      end
    end
  end

  let(:admin_domain) { 'foo-admin.3scale.net' }
  let(:access_token) { 'some-token' }

  subject(:client) { described_class.new(endpoint: "https://#{admin_domain}", access_token: access_token) }

  describe '#get' do
    let!(:stub) do
      stub_request(:get,  "https://:#{access_token}@#{admin_domain}/foo.json")
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.get('/foo') }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end

  describe '#post' do
    let!(:stub) do
      stub_request(:post, "https://:#{access_token}@#{admin_domain}/foo.json?one=1&two=2")
        .with(body: '{"bar":"baz"}')
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.post('/foo', body: { bar: 'baz' }, params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end

  describe '#put' do
    let(:body) { '' }
    let!(:stub) do
      stub_request(:put, "https://:#{access_token}@#{admin_domain}/foo.json?one=1&two=2")
        .with(body: body)
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.put('/foo', params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end

    context 'with body' do
      let(:body) { 'foobar' }
      subject { client.put('/foo', body: body, params: { one: 1, two: 2 }) }

      it 'makes a request' do
        is_expected.to be
        expect(stub).to have_been_requested
      end
    end
  end

  describe '#patch' do
    let!(:stub) do
      stub_request(:patch,  "https://:#{access_token}@#{admin_domain}/foo.json?one=1&two=2")
        .with(body: '{"bar":"baz"}')
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.patch('/foo', body: { bar: 'baz' }, params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end

  describe '#delete' do
    let!(:stub) do
      stub_request(:delete, "https://:#{access_token}@#{admin_domain}/foo.json?one=1&two=2")
        .and_return(body: '{"foo":"bar"}')
    end

    subject { client.delete('/foo', params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end
end
