# frozen_string_literal: true

require 'three_scale_api'

RSpec.describe 'ThreeScaleApi Client' do
  let(:endpoint) { 'https://test.3scale.com' }
  let(:provider_key) { 'somerandomkey' }
  subject(:client) { ThreeScaleApi::Client.new(endpoint: endpoint, provider_key: provider_key) }

  it 'should create service manager instance' do
    expect(client.services).to be_a_kind_of(ThreeScaleApi::Clients::ServiceManager)
  end

  it 'should create accounts manager instance' do
    expect(client.accounts).to be_a_kind_of(ThreeScaleApi::Clients::AccountManager)
  end

  it 'should create account plans manager instance' do
    expect(client.account_plans).to be_a_kind_of(ThreeScaleApi::Clients::AccountPlanManager)
  end

  it 'should create active doc manager instance' do
    expect(client.active_docs).to be_a_kind_of(ThreeScaleApi::Clients::ActiveDocManager)
  end

  it 'should create webhooks manager instance' do
    expect(client.webhooks).to be_a_kind_of(ThreeScaleApi::Clients::WebHookManager)
  end

  it 'should create providers manager instance' do
    expect(client.providers).to be_a_kind_of(ThreeScaleApi::Clients::ProviderManager)
  end

  it 'should create settings manager instance' do
    expect(client.settings).to be_a_kind_of(ThreeScaleApi::Clients::SettingsManager)
  end
end
