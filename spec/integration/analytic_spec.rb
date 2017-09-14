# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Analytics', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(name: name, description: name, plan_id: @app_plan['id'])
  end

  before(:all) do
    @service = create_service
    @app_plan = @service.application_plans.create(name: @name)
    @acc_resource = create_account
    @manager = @acc_resource.applications
    @app = create_res_instance(@name)

    # Keys initialization
    @keys_manager = @app.keys
    @key = @keys_manager.create(key: @name)
  end

  after(:all) do
    clean_resource(@acc_resource)
    clean_resource(@app_plan)
    clean_resource(@service)
  end

  let(:since) do
    year = Time.now.year
    Time.new(year).strftime('%Y-%m-%d')
  end

  it 'lists analytics from service by hit metrics' do
    result  = @client.analytics.list_by_service @service,
                                                metric_name: :hits,
                                                since: since

    expect(result['total']).to eq(0)
  end

  it 'lists analytics from application by hit metrics' do

    result  = @client.analytics.list_by_application @app,
                                                    metric_name: :hits,
                                                    since: since

    expect(result['total']).to eq(0)
  end
end
