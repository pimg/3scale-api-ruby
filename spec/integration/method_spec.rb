# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Method Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(friendly_name: name)
  end

  before(:all) do
    @service = create_service
    @metric = @service.metrics.list.first
    @manager = @metric.methods
    @resource = @manager.create(friendly_name: @name)
  end

  after(:all) do
    clean_resource(@service)
  end

  let(:base_attr) { 'friendly_name' }
  let(:update_params) do
    new_name = @name + '-updated'
    { param: 'system_name', value: new_name }
  end

  it_behaves_like :crud_resource
end
