# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Metric Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(friendly_name: name, unit: @unit)
  end

  before(:all) do
    @service = create_service
    @manager = @service.metrics
    @unit = 'click'
    @resource = create_res_instance(@name)
  end

  after(:all) do
    clean_resource(@service)
  end

  let(:base_attr) { 'friendly_name' }
  let(:update_params) do
    new_name = @unit + '-updated'
    { param: 'unit', value: new_name }
  end

  it_behaves_like :crud_resource
end
