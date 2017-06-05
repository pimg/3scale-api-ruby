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

  it_behaves_like :crud_resource
end
