# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Account Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    create_account(name: name)
  end

  before(:all) do
    @manager = @client.accounts
    @resource = create_res_instance
  end

  after(:all) do
    clean_resource(@resource)
  end

  let(:base_attr) { 'org_name' }
  let(:update_params) do
    { param: 'state', value: 'approved' }
  end

  it_behaves_like :crud_resource

  context 'set state' do
    it 'should reject an account' do
      @resource.reject
      expect(@manager[@resource['id']]).to res_include('state' => 'rejected')
    end
  end
end
