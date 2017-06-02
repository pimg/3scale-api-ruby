# frozen_string_literal: true

require 'three_scale_api'

RSpec.describe 'ThreeScaleApi Client' do
  let(:endpoint) { 'https://test.3scale.com' }
  let(:provider_key) { 'somerandomkey' }
  subject(:client) { ThreeScaleApi::Client.new(endpoint: endpoint, provider_key: provider_key) }

  it 'should create service manager instance' do
    expect(client.services).to be_a_kind_of(ThreeScaleApi::Clients::ServiceClient)
  end

  it 'should create accounts manager instance' do
    expect(client.accounts).to be_a_kind_of(ThreeScaleApi::Clients::AccountClient)
  end

  it 'should create account plans manager instance' do
    expect(client.account_plans).to be_a_kind_of(ThreeScaleApi::Clients::AccountPlanClient)
  end

  it 'should create active doc manager instance' do
    expect(client.active_docs).to be_a_kind_of(ThreeScaleApi::Clients::ActiveDocClient)
  end

  it 'should create webhooks manager instance' do
    expect(client.webhooks).to be_a_kind_of(ThreeScaleApi::Clients::WebHookClient)
  end

  it 'should create providers manager instance' do
    expect(client.providers).to be_a_kind_of(ThreeScaleApi::Clients::ProviderClient)
  end

  it 'should create settings manager instance' do
    expect(client.settings).to be_a_kind_of(ThreeScaleApi::Clients::SettingsClient)
  end
end
