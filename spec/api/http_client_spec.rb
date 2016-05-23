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

  describe '#post' do
    let!(:stub) {
      stub_request(:post,  "https://:#{provider_key}@#{admin_domain}/foo.json?one=1&two=2")
          .with(body: '{"bar":"baz"}')
          .and_return(body: '{"foo":"bar"}')
    }

    subject { client.post('/foo', body: {bar: 'baz'}, params: { one: 1, two: 2 }) }

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
    let!(:stub) {
      stub_request(:put,  "https://:#{provider_key}@#{admin_domain}/foo.json?one=1&two=2")
          .with(body: body)
          .and_return(body: '{"foo":"bar"}')
    }

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
    let!(:stub) {
      stub_request(:patch,  "https://:#{provider_key}@#{admin_domain}/foo.json?one=1&two=2")
          .with(body: '{"bar":"baz"}')
          .and_return(body: '{"foo":"bar"}')
    }

    subject { client.patch('/foo', body: {bar: 'baz'}, params: { one: 1, two: 2 }) }

    it 'makes a request' do
      is_expected.to be
      expect(stub).to have_been_requested
    end

    it 'returns body' do
      is_expected.to eq('foo' => 'bar')
    end
  end


  describe '#delete' do
    let!(:stub) {
      stub_request(:delete,  "https://:#{provider_key}@#{admin_domain}/foo.json?one=1&two=2")
          .and_return(body: '{"foo":"bar"}')
    }

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
