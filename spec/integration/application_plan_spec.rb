# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Application plan Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name)
    @manager.create(name: name)
  end

  before(:all) do
    @service = create_service
    @manager =  @service.application_plans
    @resource = create_res_instance(@name)
  end

  after(:all) do
    clean_resource(@service)
  end

  it_behaves_like :plan_resource
end
