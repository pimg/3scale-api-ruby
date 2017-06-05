# frozen_string_literal: true

require_relative './shared_tests_config'

# Shared test for Crud operations
RSpec.shared_examples :crud_resource do
  context 'manager reference' do
    it 'has valid manager reference' do
      expect(@resource.manager).to eq(@manager)
    end
  end

  context 'Create' do
    it 'should create resource' do
      expect(@resource).to res_include(base_attr => @name)
    end
  end

  context 'List' do
    it 'should list resource' do
      res_name = @resource[base_attr]
      expect(@manager.list.any? { |res| res[base_attr] == res_name }).to be(true)
    end
  end

  context 'Read' do
    it 'should read resource' do
      expect(@manager.read(@resource['id'])).to res_include(base_attr => @name)
    end
  end

  context 'Prepare' do
    it 'should prepare resource' do
      res = @manager.prepare(@resource['id'])
      expect(res.instance_variable_get(:@entity)).to be_nil
      expect(res.instance_variable_get(:@entity_id)).to eq(@resource['id'])

      expect(res.entity).to be_truthy
      expect(res.entity).to include(base_attr => @name)
      expect(res.instance_variable_get(:@entity)).to be_truthy

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

  context 'Find' do
    it 'should find resource' do
      resource = @manager[@resource[base_attr]]
      expect(resource).to be_truthy
      expect(resource).to res_include('id' => @resource['id'])
      resource_id = @manager[@resource['id']]
      expect(resource_id).to res_include(base_attr => @name)
    end
  end

  context 'Valid references' do
    it 'should have valid reference to manager' do
      expect(@resource.manager).to eq(@manager)
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
