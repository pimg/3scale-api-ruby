# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Service Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    create_service(name: name)
  end

  before(:all) do
    @manager = @client.services
    @resource = create_res_instance
  end

  after(:all) do
    clean_resource(@resource)
  end

  let(:base_attr) { 'system_name' }
  let(:update_params) do
    new_name = @name + '-updated'
    { param: 'name', value: new_name }
  end

  it_behaves_like :crud_resource
end
