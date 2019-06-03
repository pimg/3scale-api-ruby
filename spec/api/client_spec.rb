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

  context '#proxy_config_list' do
    let(:service_id) { '1001' }
    let(:config_list) { [{'id': 1}] }

    it 'default value is sandbox' do
      expect(http_client).to receive(:get)
        .with("/admin/api/services/#{service_id}/proxy/configs/sandbox")
        .and_return('proxy' => config_list)
      expect(client.proxy_config_list(service_id)).to eq(config_list)
    end

    it 'production proxy config list' do
      expect(http_client).to receive(:get)
        .with("/admin/api/services/#{service_id}/proxy/configs/production")
        .and_return('proxy' => config_list)
      expect(client.proxy_config_list(service_id, 'production')).to eq(config_list)
    end
  end

  context '#proxy_config_latest' do
    let(:service_id) { '1001' }
    let(:proxy_config) { {'id': 1} }

    it 'default value is sandbox' do
      expect(http_client).to receive(:get)
        .with("/admin/api/services/#{service_id}/proxy/configs/sandbox/latest")
        .and_return('proxy' => proxy_config)
      expect(client.proxy_config_latest(service_id)).to eq(proxy_config)
    end

    it 'production proxy config latest' do
      expect(http_client).to receive(:get)
        .with("/admin/api/services/#{service_id}/proxy/configs/production/latest")
        .and_return('proxy' => proxy_config)
      expect(client.proxy_config_latest(service_id, 'production')).to eq(proxy_config)
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

  context '#delete_mapping_rule' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/services/42/proxy/mapping_rules/21')
        .and_return(' ')
      expect(client.delete_mapping_rule(42, 21)).to eq(true)
    end
  end

  context '#show_metric' do
    let(:service_id) { 300 }
    let(:metric_id) { 100 }
    let(:metric) { { 'id' => metric_id } }
    let(:response_body) { { 'metric' => metric } }

    it do
      expect(http_client).to receive(:get).with("/admin/api/services/#{service_id}/metrics/#{metric_id}")
                                          .and_return(response_body)
      expect(client.show_metric(service_id, metric_id)).to eq(metric)
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

  context '#update_metric' do
    let(:service_id) { 200 }
    let(:metric_id) { 1000 }
    let(:metric_attrs) { { 'unit' => '1' } }
    let(:metric) { metric_attrs.merge('id' => metric_id) }
    let(:response_body) { { 'metric' => metric } }

    it do
      expect(http_client).to receive(:put)
        .with("/admin/api/services/#{service_id}/metrics/#{metric_id}", body: { metric: metric_attrs })
        .and_return(response_body)
      expect(client.update_metric(service_id, metric_id, metric_attrs)).to eq(metric)
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

  context '#show_method' do
    let(:service_id) { 300 }
    let(:parent_id) { 100 }
    let(:method_id) { 200 }
    let(:method) { { 'id' => method_id } }
    let(:response_body) { { 'method' => method } }

    it do
      expect(http_client).to receive(:get).with("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{method_id}")
                                          .and_return(response_body)
      expect(client.show_method(service_id, parent_id, method_id)).to eq(method)
    end
  end

  context '#update_method' do
    let(:service_id) { 300 }
    let(:parent_id) { 100 }
    let(:method_id) { 200 }
    let(:method_attrs) { { 'description' => "some descr" } }
    let(:method) { method_attrs.merge('id' => method_id) }
    let(:response_body) { { 'method' => method } }

    it do
      expect(http_client).to receive(:put)
        .with("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{method_id}", body: { metric: method_attrs })
        .and_return(response_body)
      expect(client.update_method(service_id, parent_id, method_id, method_attrs)).to eq(method)
    end
  end

  context '#delete_method' do
    let(:service_id) { 300 }
    let(:parent_id) { 100 }
    let(:method_id) { 200 }

    it do
      expect(http_client).to receive(:delete)
        .with("/admin/api/services/#{service_id}/metrics/#{parent_id}/methods/#{method_id}")
      expect(client.delete_method(service_id, parent_id, method_id)).to eq(true)
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

  context '#show_application_plan' do
    let(:plan) { { 'id' => 1 } }
    let(:response_body) { { 'application_plan' => plan } }

    it do
      expect(http_client).to receive(:get).with('/admin/api/services/1000/application_plans/200')
                                          .and_return(response_body)
      expect(client.show_application_plan(1000, 200)).to eq(plan)
    end
  end

  context '#update_application_plan' do
    let(:plan_attrs) { { 'name' => 'new_name'} }
    let(:plan_a) { { 'id' => 200 } }
    let(:response_body) { { 'application_plan' => plan_a } }

    it do
      expect(http_client).to receive(:patch).with('/admin/api/services/1000/application_plans/200',
                                                  body: { application_plan: plan_attrs })
                                            .and_return(response_body)
      expect(client.update_application_plan(1000, 200, plan_attrs)).to eq(plan_a)
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

  context '#list_metric_limits' do
    let(:plan_id) { 200 }
    let(:metric_id) { 1000 }
    let(:limit_0) { { 'id' => 0, 'metric_id' => metric_id, 'period' => 'eternity', 'value' => 1000 } }
    let(:limit_1) { { 'id' => 1, 'metric_id' => metric_id, 'period' => 'year', 'value' => 1000 } }
    let(:response_body) do
      {
        'limits' => [
          { 'limit' => limit_0 },
          { 'limit' => limit_1 }
        ]
      }
    end

    it do
      expect(http_client).to receive(:get)
        .with("/admin/api/application_plans/#{plan_id}/metrics/#{metric_id}/limits")
        .and_return(response_body)
      expect(client.list_metric_limits(plan_id, metric_id)).to eq([limit_0, limit_1])
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

  context '#update_application_plan_limit' do
    let(:plan_id) { 200 }
    let(:metric_id) { 1000 }
    let(:limit_id) { 3000 }
    let(:limit) { { 'id' => limit_id, 'period' => 'eternity', 'value' => 1000 } }
    let(:response_body) { { 'limit' => limit } }

    it do
      expect(http_client).to receive(:put).with("/admin/api/application_plans/#{plan_id}/metrics/#{metric_id}/limits/#{limit_id}",
                                                body: { usage_limit: limit })
                                          .and_return(response_body)
      expect(client.update_application_plan_limit(plan_id, metric_id, limit_id, limit)).to eq limit
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

  context '#application_plan_as_default' do
    let(:service_id) { 1000 }
    let(:plan_id) { 200 }
    let(:plan) { { 'id' => 200, 'default' => true } }
    let(:response_body) { { 'application_plan' => plan } }

    it do
      expect(http_client).to receive(:put)
        .with("/admin/api/services/#{service_id}/application_plans/#{plan_id}/default")
        .and_return(response_body)
      expect(client.application_plan_as_default(service_id, plan_id)).to eq plan
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

  context '#list_activedocs' do
    let(:api_doc) { {id: '44' } }
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/active_docs')
        .and_return('api_docs' => [{'api_doc' => api_doc}])
      expect(client.list_activedocs).to eq [api_doc]
    end
  end

  context '#create_activedocs' do
    let(:attributes) { {} }
    let(:api_doc) { { id: '44' } }
    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/active_docs', body: attributes)
        .and_return('api_doc' => api_doc)
      expect(client.create_activedocs(attributes)).to eq api_doc
    end
  end

  context '#update_activedocs' do
    let(:api_doc_id) { '44' }
    let(:attributes) { {} }
    let(:api_doc) { { id: api_doc_id } }
    it do
      expect(http_client).to receive(:put)
        .with("/admin/api/active_docs/#{api_doc_id}", body: attributes)
        .and_return('api_doc' => api_doc)
      expect(client.update_activedocs(api_doc_id, attributes)).to eq api_doc
    end
  end

  context '#delete_activedocs' do
    let(:api_doc_id) { '44' }
    it do
      expect(http_client).to receive(:delete)
        .with("/admin/api/active_docs/#{api_doc_id}")
      expect(client.delete_activedocs(api_doc_id)).to be_truthy
    end
  end

  context '#list_accounts' do
    let(:account) do
      {
        'id' => 1
      }
    end
    let(:accounts) do
      {
        'accounts' => [
          {
            'account' => account
          }
        ]
      }
    end

    it do
      expect(http_client).to receive(:get).with('/admin/api/accounts').and_return(accounts)
      expect(client.list_accounts).to include(account)
    end
  end

  context '#delete_account' do
    it do
      expect(http_client).to receive(:delete).with('/admin/api/accounts/1').and_return(nil)
      expect(client.delete_account(1)).to eq(true)
    end
  end

  context '#delete_application' do
    it do
      expect(http_client).to receive(:delete).with('/admin/api/accounts/1/applications/10')
        .and_return(nil)
      expect(client.delete_application(1, 10)).to eq(true)
    end
  end

  context '#delete_application_plan_customization' do
    let(:plan) { { 'id' => 1 } }
    let(:plan_reponse) { { 'application_plan' => plan } }

    it do
      expect(http_client).to receive(:put).with('/admin/api/accounts/10/applications/100/decustomize_plan')
        .and_return(plan_reponse)
      expect(client.delete_application_plan_customization(10, 100)).to include(plan)
    end
  end
  context '#show_oidc' do
    let(:service_id) { '1001' }
    let(:oidc_configuration) {
      {
        standard_flow_enabled: false,
        implicit_flow_enabled: false,
        service_accounts_enabled: true,
        direct_access_grants_enabled: false
      }
    }

    it do
      expect(http_client).to receive(:get)
        .with("/admin/api/services/#{service_id}/proxy/oidc_configuration")
        .and_return('oidc_configuration' => oidc_configuration)
      expect(client.show_oidc(service_id)).to eq(oidc_configuration)
    end
  end

  context '#update_oidc' do
    let(:service_id) { '1001' }
    let(:oidc_configuration) {
      {
        standard_flow_enabled: false,
        implicit_flow_enabled: false,
        service_accounts_enabled: true,
        direct_access_grants_enabled: false
      }
    }

    it do
      expect(http_client).to receive(:patch)
        .with("/admin/api/services/#{service_id}/proxy/oidc_configuration", body: { oidc_configuration: oidc_configuration })
        .and_return('oidc_configuration' => {'id' => 42})
      expect(client.update_oidc(service_id, oidc_configuration)).to eq({'id' => 42})
    end
  end

  context '#list_features_per_application_plan' do
    let(:feature_a) do
      {
        'id' => 1
      }
    end
    let(:features) do
      {
        'features' => [
          {
            'feature' => feature_a
          }
        ]
      }
    end
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/application_plans/100/features').and_return(features)
      expect(client.list_features_per_application_plan(100)).to match_array([feature_a])
    end
  end

  context '#create_application_plan_feature' do
    let(:feature_a) { { 'id' => 200 } }
    let(:create_body) { { feature_id: feature_a.fetch('id') } }
    let(:response_body) { { 'feature' => feature_a } }

    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/application_plans/1000/features', body: create_body)
        .and_return(response_body)
      expect(client.create_application_plan_feature(1000, 200)).to eq(feature_a)
    end
  end

  context '#delete_application_plan_feature' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/application_plans/1000/features/200').and_return(' ')
      expect(client.delete_application_plan_feature(1000, 200)).to eq(true)
    end
  end

  context '#list_service_features' do
    let(:feature_a) { { 'id' => 1 } }
    let(:feature_b) { { 'id' => 2 } }
    let(:features) do
      {
        'features' => [
          {
            'feature' => feature_a
          },
          {
            'feature' => feature_b
          }
        ]
      }
    end
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/1000/features').and_return(features)
      expect(client.list_service_features(1000)).to match_array([feature_a, feature_b])
    end
  end

  context '#create_service_feature' do
    let(:feature_attrs) { { 'name' => 'feature_a'} }
    let(:feature_a) { { 'id' => 200 } }
    let(:response_body) { { 'feature' => feature_a } }

    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/services/1000/features', body: { feature: feature_attrs })
        .and_return(response_body)
      expect(client.create_service_feature(1000, feature_attrs)).to eq(feature_a)
    end
  end

  context '#show_service_feature' do
    let(:feature_a) { { 'id' => 200 } }
    let(:response_body) { { 'feature' => feature_a} }
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/services/1000/features/200')
        .and_return(response_body)
      expect(client.show_service_feature(1000, 200)).to eq(feature_a)
    end
  end

  context '#update_service_feature' do
    let(:feature_attrs) { { 'name' => 'new_name'} }
    let(:feature_a) { { 'id' => 200 } }
    let(:response_body) { { 'feature' => feature_a } }

    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/services/1000/features/200', body: { feature: feature_attrs })
        .and_return(response_body)
      expect(client.update_service_feature(1000, 200, feature_attrs)).to eq(feature_a)
    end
  end

  context '#delete_service_feature' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/services/1000/features/200').and_return(' ')
      expect(client.delete_service_feature(1000, 200)).to eq(true)
    end
  end

  context '#delete_metric' do
    let(:service_id) { 2000 }
    let(:metric_id) { 1000 }
    it do
      expect(http_client).to receive(:delete)
        .with("/admin/api/services/#{service_id}/metrics/#{metric_id}")
        .and_return({})
      expect(client.delete_metric(service_id, metric_id)).to eq(true)
    end
  end

  context '#list_policy_registry' do
    let(:policy_registry_a) { { 'id' => 1 } }
    let(:policy_registry_b) { { 'id' => 2 } }
    let(:policies) do
      {
        'policies' => [
          {
            'policy' => policy_registry_a
          },
          {
            'policy' => policy_registry_b
          }
        ]
      }
    end
    it do
      expect(http_client).to receive(:get)
        .with('/admin/api/registry/policies').and_return(policies)
      expect(client.list_policy_registry).to match_array([policy_registry_a, policy_registry_b])
    end
  end

  context '#create_policy_registry' do
    let(:policy_attrs) { { 'name' => 'policy A'} }
    let(:policy_a) { { 'id' => 200 } }
    let(:response_body) { { 'policy' => policy_a } }

    it do
      expect(http_client).to receive(:post)
        .with('/admin/api/registry/policies', body: policy_attrs)
        .and_return(response_body)
      expect(client.create_policy_registry(policy_attrs)).to eq(policy_a)
    end
  end

  context '#show_policy_registry' do
    let(:policy_a) { { 'id' => 200 } }
    let(:response_body) { { 'policy' => policy_a } }
    it do
      expect(http_client).to receive(:get).with('/admin/api/registry/policies/200')
                                          .and_return(response_body)
      expect(client.show_policy_registry(200)).to eq(policy_a)
    end
  end

  context '#update_policy_registry' do
    let(:policy_attrs) { { 'name' => 'policy A'} }
    let(:policy_a) { { 'id' => 200 } }
    let(:response_body) { { 'policy' => policy_a } }

    it do
      expect(http_client).to receive(:put)
        .with('/admin/api/registry/policies/200', body: policy_attrs)
        .and_return(response_body)
      expect(client.update_policy_registry(200, policy_attrs)).to eq(policy_a)
    end
  end

  context '#delete_policy_registry' do
    it do
      expect(http_client).to receive(:delete)
        .with('/admin/api/registry/policies/200').and_return(' ')
      expect(client.delete_policy_registry(200)).to eq(true)
    end
  end
end
