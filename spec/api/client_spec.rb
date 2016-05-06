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

  context '#show_proxy' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/services/42/proxy').and_return('proxy' => {})
      expect(client.show_proxy(42)).to eq({})
    end
  end

  context '#update_proxy' do
    it do
      expect(http_client).to receive(:patch)
                                 .with('/admin/api/services/42/proxy', body: { proxy: {} })
                                 .and_return('proxy' => {})
      expect(client.update_proxy(42, {})).to eq({})
    end
  end

  context '#list_applications' do
    it do
      expect(http_client).to receive(:get).with('/admin/api/applications').and_return('applications' => [])
      expect(client.list_applications).to eq([])
    end
  end

  context '#list_mapping_rules' do
    it do
      expect(http_client).to receive(:get)
                                 .with('/admin/api/services/42/proxy/mapping_rules')
                                 .and_return('mapping_rules' => [{'mapping_rule' => {}}])
      expect(client.list_mapping_rules(42)).to eq([{}])
    end
  end

  context '#show_mapping_rule' do
    it do
      expect(http_client).to receive(:get)
                                 .with('/admin/api/services/42/proxy/mapping_rules/21')
                                 .and_return('mapping_rule' => {})
      expect(client.show_mapping_rule(42, 21)).to eq({})
    end
  end

  context '#create_mapping_rule' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/proxy/mapping_rules',
                                       body: { mapping_rule: { http_method: 'GET'}})
                                 .and_return('mapping_rule' => { 'http_method' => 'GET'})
      expect(client.create_mapping_rule(42, http_method: 'GET')).to eq('http_method' => 'GET')
    end
  end

  context '#create_mapping_rule' do
    it do
      expect(http_client).to receive(:delete)
                                 .with('/admin/api/services/42/proxy/mapping_rules/21')
                                 .and_return(' ')
      expect(client.delete_mapping_rule(42, 21)).to eq(true)
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

  context '#list_methods' do
    it do
      expect(http_client).to receive(:get)
                                 .with('/admin/api/services/42/metrics/21/methods')
                                 .and_return('methods' => [])
      expect(client.list_methods(42, 21)).to eq([])
    end
  end

  context '#crete_method' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/metrics/21/methods', body: { metric: {}})
                                 .and_return('method' => {})
      expect(client.create_method(42, 21, {})).to eq({})
    end
  end

  context '#list_service_application_plans' do
    it do
      expect(http_client).to receive(:get)
                                 .with('/admin/api/services/42/application_plans')
                                 .and_return('plans' => [{'application_plan' => {}}])
      expect(client.list_service_application_plans(42)).to eq([{}])
    end
  end

  context '#create_application_plan' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/services/42/application_plans', body: { application_plan: {}})
                                 .and_return('application_plan' => {})
      expect(client.create_application_plan(42, {})).to eq({})
    end
  end

  context '#list_application_plan_limits' do
    it do
      expect(http_client).to receive(:get)
                                 .with('/admin/api/application_plans/42/limits')
                                 .and_return('limits' => [{'limit' => {}}])
      expect(client.list_application_plan_limits(42)).to eq([{}])
    end
  end

  context '#create_application_plan_limit' do
    it do
      expect(http_client).to receive(:post)
                                 .with('/admin/api/application_plans/42/metrics/21/limits', body: { usage_limit: {}})
                                 .and_return('limit' => {})
      expect(client.create_application_plan_limit(42, 21, {})).to eq({})
    end
  end

  context '#delete_application_plan_limit' do
    it do
      expect(http_client).to receive(:delete)
                                 .with('/admin/api/application_plans/42/metrics/21/limits/10')
                                 .and_return(nil)
      expect(client.delete_application_plan_limit(42, 21, 10)).to eq(true)
    end
  end


end
