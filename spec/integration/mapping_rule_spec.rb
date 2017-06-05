# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Mapping rule Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(http_method: 'DELETE', pattern: name, delta: 1)
  end

  let(:random_gen_name) { '/' + SecureRandom.uuid }
  let(:skip_find) { true }

  before(:all) do
    @service = create_service
    @metric = @service.metrics.list.first
    @manager = @service.mapping_rules(@metric)
    @name = "/#{@name}"
    @resource = create_res_instance(@name)
  end

  after(:all) do
    clean_resource(@service)
  end

  let(:base_attr) { 'pattern' }
  let(:update_params) do
    { param: 'delta', value: 10 }
  end

  it_behaves_like :crud_resource
end
