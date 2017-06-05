# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Account plan Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(name: name)
  end

  before(:all) do
    @manager = @client.account_plans
    @resource = create_res_instance(@name)
  end

  after(:all) do
    clean_resource(@resource)
  end

  it_behaves_like :plan_resource
end
