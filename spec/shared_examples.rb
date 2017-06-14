# frozen_string_literal: true

require_relative './shared_tests_config'

# Shared test for Crud operations
RSpec.shared_examples :crud_resource do
  context 'Create' do
    it 'should create resource' do
      expect(@resource).to res_include(base_attr => @name)
    end
  end

  context 'Update' do
    it 'should update resource' do
      param = update_params[:param]
      value = update_params[:value]
      @resource[param] = value
      expect(@resource.update).to res_include(param => value)
      expect(@resource).to res_include(param => value)
    end
  end

  context 'Delete' do
    it 'should delete resource' do
      res_name = random_gen_name
      resource = create_res_instance(res_name)
      expect(resource).to res_include(base_attr => res_name)
      resource.delete
      expect(@manager.list.any? { |r| r[base_attr] == res_name }).to be(false)
    end
  end

  context 'List' do
    it 'should list resource' do
      res_name = @resource[base_attr]
      expect(@manager.list.any? { |res| res[base_attr] == res_name }).to be(true)
    end
  end

  context 'Find' do
    it 'should find resource' do
      resource = @manager[@resource[base_attr]]
      expect(resource).to be_truthy
      expect(resource).to res_include('id' => @resource['id'])
      resource_id = @manager[@resource['id']]
      expect(resource_id).to res_include(base_attr => @name)
    end
  end

  context 'Read' do
    it 'should not call http_client get' do
      expect(@manager.http_client).not_to receive(:get)
      @manager.read(@resource['id'])
    end

    it 'should fetch resource and call http_client get' do
      entity_name = @manager.entity_name
      expect(@manager.http_client).to receive(:get).and_return(
        entity_name.to_s => { base_attr => @name }
      )
      res = @manager.read(@resource['id'])
      expect(res.entity).to be_truthy
      expect(res).to res_include(base_attr => @name)
    end
  end

  context 'Fetch' do
    it 'should prepare resource' do
      expect(@manager.fetch(@resource['id'])).to res_include(base_attr => @name)
    end
  end
end

# Shared example for all plan resources and managers.
# It runs shared crud tests and List all with get and set default plan
RSpec.shared_examples :plan_resource do
  let(:base_attr) { 'name' }
  let(:update_params) do
    { param: 'state', value: 'published' }
  end

  it_behaves_like :crud_resource

  context 'List all' do
    it 'should list all plans' do
      res_name = @resource[base_attr]
      expect(@manager.list_all.any? { |res| res[base_attr] == res_name }).to be(true)
    end
  end

  context 'Set and Get default' do
    it 'should set_default and get_default plan' do
      old_default = @manager.get_default
      if old_default
        expect(@manager[old_default['id']]).to res_include('default' => true)
      end

      @resource.set_default

      expect(@manager[@resource['id']]).to res_include('default' => true)
      if old_default
        old_default.set_default
        expect(@manager[old_default['id']]).to res_include('default' => true)
      end
    end
  end
end

RSpec.shared_examples :user_resource do
  let(:base_attr) { 'username' }
  let(:update_params) do
    new_name = @name + '-updated@example.com'
    { param: 'email', value: new_name }
  end

  it_behaves_like :crud_resource

  context 'Activate' do
    it 'should activate provider' do
      expect(@resource['state']).to eq('pending')
      @resource.activate
      expect(@manager[@resource['id']]).to res_include('state' => 'active')
    end
  end

  context 'set admin' do
    it 'should set provider as admin' do
      expect(@resource['role']).to eq('member')
      @resource.as_admin
      expect(@manager[@resource['id']]).to res_include('role' => 'admin')
    end
  end
end
