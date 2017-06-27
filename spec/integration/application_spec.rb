# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Application Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(name: name, description: name, plan_id: @app_plan['id'])
  end

  before(:all) do
    @service = create_service
    @app_plan = @service.application_plans.create(name: @name)
    @acc_resource = create_account
    @manager = @acc_resource.applications
    @resource = create_res_instance(@name)

    # Keys initialization
    @keys_manager = @resource.keys
    @key = @keys_manager.create(key: @name)
  end

  after(:all) do
    clean_resource(@acc_resource)
    clean_resource(@app_plan)
    clean_resource(@service)
  end

  let(:base_attr) { 'name' }
  let(:update_params) do
    new_name = @name + '-updated'
    { param: 'description', value: new_name }
  end

  it_behaves_like :crud_resource

  context 'Has valid references' do
    it 'should have valid service reference' do
      app_service = @resource.service
      expect(app_service).to be_truthy
      expect(app_service).to be_a ThreeScaleApi::Resources::Service
      expect(app_service).to res_include('id' => @service['id'])
    end

    it 'should have valid application plan reference' do
      plan = @resource.application_plan
      expect(plan).to be_truthy
      expect(plan).to be_a ThreeScaleApi::Resources::ApplicationPlan
      expect(plan).to res_include('id' => @app_plan['id'])
    end
  end

  context 'Set application state' do
    it 'should activate application' do
      @resource.suspend
      expect(@manager[@resource['id']]).to res_include('state' => 'suspended')
      @resource.resume
      expect(@manager[@resource['id']]).to res_include('state' => 'live')
    end
  end

  context 'keys' do
    it 'should create key' do
      expect(@keys_manager.list.any? { |res| res['value'] == @name }).to be(true)
    end

    it 'should list keys' do
      expect(@keys_manager.list.any? { |res| res['value'] == @name }).to be(true)
    end

    it 'should delete key' do
      res_name = SecureRandom.uuid
      resource = @keys_manager.create(key: res_name)
      expect(resource['value']).to eq(res_name)
      expect(@keys_manager.list.any? { |res| res['value'] == res_name }).to be(true)
      resource.delete
      expect(@manager.list.any? { |r| r['value'] == res_name }).to be(false)
    end
  end
end
