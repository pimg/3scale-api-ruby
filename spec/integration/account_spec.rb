require 'securerandom'

RSpec.describe 'Account API', type: :integration do
  let(:endpoint) { ENV.fetch('ENDPOINT') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID').to_i }
  let(:application_plan_id) { ENV.fetch('APPLICATION_PLAN_ID').to_i }
  let(:verify_ssl) { !(ENV.fetch('VERIFY_SSL', 'true').to_s =~ /(true|t|yes|y|1)$/i).nil? }

  subject(:client) do
    ThreeScale::API.new(endpoint: endpoint, provider_key: provider_key,
                        verify_ssl: verify_ssl)
  end

  context '#signup' do
    let(:name) { SecureRandom.hex(14) }
    let(:email) { "#{name}@example.com" }

    subject(:signup) do
      client.signup(name: name, username: name,
                    billing_address_city: 'Barcelona',
                    'billing_address_country' => 'Spain')
    end

    it 'creates an account' do
      expect(signup).to include('org_name' => name)
      expect(signup['billing_address']).to include('company' => name, 'city' => 'Barcelona', 'country' => 'Spain')
    end

    context '#create_application' do
      let(:account_id) { signup.fetch('id') }
      subject(:create) do
        client.create_application(account_id,
                                  plan_id: application_plan_id,
                                  user_key: name,
                                  application_id: name,
                                  application_key: name)
      end
      it 'creates an application' do
        expect(create).to include('user_key' => name, 'service_id' => service_id)
      end

      context '#show_application' do
        let(:application_id) { create.fetch('id') }

        subject(:show) { client.show_application(application_id) }

        it do
          expect(show).to include('id' => application_id, 'service_id' => service_id)
        end
      end

      context '#find_application' do
        let(:application_id) { create.fetch('id') }
        let(:user_key) { create.fetch('user_key') }

        it 'finds by id' do
          find = client.find_application(id: application_id)
          expect(find).to include('id' => application_id, 'service_id' => service_id)
        end

        it 'finds by user_key' do
          find = client.find_application(user_key: user_key)
          expect(find).to include('id' => application_id, 'user_key' => user_key)
        end

        pending 'finds by application_id' do
          find = client.find_application(application_id: user_key)
          expect(find).to include('id' => application_id, 'user_key' => user_key)
        end
      end

      context '#customize_application_plan' do
        let(:application_id) { create.fetch('id') }

        subject(:customize) { client.customize_application_plan(account_id, application_id) }

        it 'creates custom plan' do
          expect(customize).to include('custom' => true, 'default' => false, 'state' => 'hidden')
          expect(customize['name']).to match('(custom)')
          expect(customize['system_name']).to match('custom')
        end
      end
    end
  end
end
