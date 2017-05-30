# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Provider Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    create_provider(name: name)
  end

  before(:all) do
    @manager = @client.providers
    @resource = create_res_instance
  end

  after(:all) do
    clean_resource(@resource)
  end

  it_behaves_like :user_resource
end
