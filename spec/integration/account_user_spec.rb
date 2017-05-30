# frozen_string_literal: true

require_relative '../shared_examples'

RSpec.describe 'Account user Resource', type: :integration do
  include_context 'Shared initialization'

  def create_res_instance(name = nil)
    @manager.create(username: name,
                    password: name,
                    email: "#{name}@example.com")
  end

  before(:all) do
    @endpoint = ENV.fetch('ENDPOINT')
    @provider_key = ENV.fetch('PROVIDER_KEY')
    @acc_name = SecureRandom.uuid
    @name = SecureRandom.uuid
    @acc_resource = create_account(name: @acc_name)
    @manager = @acc_resource.users
    @resource = create_res_instance(@name)
  end

  after(:all) do
    clean_resource(@acc_resource)
  end

  it_behaves_like :user_resource
end
