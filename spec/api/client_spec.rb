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
        .with('/admin/api/services', body: { service: {} })
        .and_return('service' => {})
      expect(client.create_service({})).to eq({})
    end
  end

  context '#update_service' do
    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/services/42', body: { service: { name: 'Updated Service'} })
        .and_return('service' => {'id' => 42})
      expect(client.update_service(42, { name: 'Updated Service' })).to eq({'id' => 42})
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
      expect(http_client).to receive(:get)
        .with('/admin/api/applications', params: nil)
        .and_return('applications' => [])
      expect(client.list_applications).to eq([])
    end

    it 'filters by service' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications', params: { service_id: 42 })
        .and_return('applications' => [])
      expect(client.list_applications(service_id: 42)).to eq([])
    end
  end

  context '#show_application' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { application_id: 42 })
        .and_return('application' => { 'id' => 42 })
      expect(client.show_application(42)).to eq('id' => 42)
    end
  end

  context '#find_application' do
    it 'finds by id' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { application_id: 42 })
        .and_return('application' => { 'id' => 42 })
      expect(client.find_application(id: 42)).to eq('id' => 42)
    end

    it 'finds by user_key' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { user_key: 'hex' })
        .and_return('application' => { 'user_key' => 'hex' })
      expect(client.find_application(user_key: 'hex')).to eq('user_key' => 'hex')
    end

    it 'finds by app_id' do
      expect(http_client).to receive(:get)
        .with('/admin/api/applications/find', params: { app_id: 'hex' })
        .and_return('application' => { 'app_id' => 'hex' })
      expect(client.find_application(application_id: 'hex')).to eq('app_id' => 'hex')
    end
  end

  context '#create_application' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/accounts/42/applications', body: {
                name: 'foo',
                description: 'foo description',
                plan_id: 21,
                'user_key' => 'foobar',
                applicaton_key: 'hex'
              })
        .and_return('application' => { 'id' => 42 })
      expect(client.create_application(42,
                                       plan_id: 21, name: 'foo', description: 'foo description',
                                       'user_key' => 'foobar',
                                       applicaton_key: 'hex')).to eq('id' => 42)
    end
  end

  context '#customize_application_plan' do
    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/accounts/42/applications/21/customize_plan')
        .and_return('application_plan' => { 'id' => 11 })

      expect(client.customize_application_plan(42, 21)).to eq('id' => 11)
    end
  end

  context '#signup' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/signup', body: { org_name: 'foo',
                                           username: 'foobar',
                                           email: 'foo@example.com',
                                           password: 'pass',
                                           'billing_address_country' => 'Spain',
                                           billing_address_city: 'Barcelona' })
        .and_return('account' => { 'id' => 42 })
      expect(client.signup(name: 'foo', username: 'foobar', password: 'pass',
                           billing_address_city: 'Barcelona', email: 'foo@example.com',
                           'billing_address_country' => 'Spain'))
        .to eq('id' => 42)
    end
  end

  context '#list_mapping_rules' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/proxy/mapping_rules')
        .and_return('mapping_rules' => [{ 'mapping_rule' => {} }])
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
              body: { mapping_rule: { http_method: 'GET' } })
        .and_return('mapping_rule' => { 'http_method' => 'GET' })
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
        .with('/admin/api/services/42/metrics', body: { metric: {} })
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
        .with('/admin/api/services/42/metrics/21/methods', body: { metric: {} })
        .and_return('method' => {})
      expect(client.create_method(42, 21, {})).to eq({})
    end
  end

  context '#list_service_application_plans' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/42/application_plans')
        .and_return('plans' => [{ 'application_plan' => {} }])
      expect(client.list_service_application_plans(42)).to eq([{}])
    end
  end

  context '#create_application_plan' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/42/application_plans', body: { application_plan: {} })
        .and_return('application_plan' => {})
      expect(client.create_application_plan(42, {})).to eq({})
    end
  end

  context '#list_application_plan_limits' do
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/application_plans/42/limits')
        .and_return('limits' => [{ 'limit' => {} }])
      expect(client.list_application_plan_limits(42)).to eq([{}])
    end
  end

  context '#create_application_plan_limit' do
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/application_plans/42/metrics/21/limits', body: { usage_limit: {} })
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

  context '#delete_service' do
    let(:service_id) { 41 }
    it do
      expect(http_client).to receive(:delete)
        .with("/admin/api/services/#{service_id}")
        .and_return(nil)
      expect(client.delete_service(service_id)).to be_truthy
    end
  end
  context '#delete_application_plan' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/services/42/application_plans/21')
        .and_return(nil)
      expect(client.delete_application_plan(42,21)).to eq(true)
    end
  end

  context '#find_account' do
    let(:criteria) { double('criteria') }
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/accounts/find', params: criteria)
        .and_return('account' => { 'id' => 42 })
      expect(client.find_account(criteria)).to eq('id' => 42)
    end
  end

  context '#show_policies' do
    let(:service_id) { 31 }
    let(:threescale_policy) do
      {
        'name' => 'apicast',
        'version' => 'builtin',
        'configuration' => {},
        'enabled' => true
      }
    end
    let(:soap_policy) do
      {
        'name' => 'soap',
        'version' => 'builtin',
        'configuration' => {},
        'enabled' => true
      }
    end

    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/31/proxy/policies')
        .and_return('policies_config' => [threescale_policy, soap_policy])
      expect(client.show_policies(service_id)).to eq([threescale_policy, soap_policy])
    end
  end

  context '#update_policies' do
    let(:service_id) { 31 }
    let(:policies_config) { [] }
    let(:threescale_policy) do
      {
        'name' => 'apicast',
        'version' => 'builtin',
        'configuration' => {},
        'enabled' => true
      }
    end
    let(:soap_policy) do
      {
        'name' => 'soap',
        'version' => 'builtin',
        'configuration' => {},
        'enabled' => true
      }
    end

    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/services/31/proxy/policies', body: policies_config)
        .and_return('policies_config' => [threescale_policy, soap_policy])
      expect(client.update_policies(service_id, policies_config)).to eq([threescale_policy, soap_policy])
    end
  end

  context '#list_pricingrules_per_metric' do
    let(:pricingrule) { { id: '44' } }
    let(:application_plan_id) { '10' }
    let(:metric_id) { '20' }
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/application_plans/10/metrics/20/pricing_rules')
        .and_return('pricing_rules' => [{'pricing_rule' => pricingrule}])
      expect(client.list_pricingrules_per_metric(application_plan_id, metric_id)).to eq [pricingrule]
    end
  end

  context '#list_pricingrules_per_application_plan' do
    let(:pricingrule) { { id: '44' } }
    let(:application_plan_id) { '10' }
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/application_plans/10/pricing_rules')
        .and_return('pricing_rules' => [{'pricing_rule' => pricingrule}])
      expect(client.list_pricingrules_per_application_plan(application_plan_id)).to eq [pricingrule]
    end
  end

  context '#create_pricingrule' do
    let(:attributes) { {} }
    let(:pricingrule) { { id: '44' } }
    let(:application_plan_id) { '10' }
    let(:metric_id) { '20' }
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/application_plans/10/metrics/20/pricing_rules', body: attributes)
        .and_return('pricing_rule' => pricingrule)
      expect(client.create_pricingrule(application_plan_id, metric_id, attributes)).to eq pricingrule
    end
  end
end
