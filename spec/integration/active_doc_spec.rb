# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Active Doc Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    create_active_doc(name: name)
  end

  before(:all) do
    @manager = @client.active_docs
    @resource = create_active_doc
  end

  after(:all) do
    clean_resource(@resource)
  end

  let(:base_attr) { 'name' }
  let(:update_params) do
    { param: 'published', value: true }
  end

  context 'CRUD Operations' do
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
      it 'should read resource' do
        expect(@manager.read(@resource['id'])).to res_include(base_attr => @name)
      end
    end
  end
end
