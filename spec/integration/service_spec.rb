RSpec.describe 'Service API', type: :integration do

  let(:admin_domain) { ENV.fetch('ADMIN_DOMAIN') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID') }

  subject!(:client) { ThreeScale::API.new(admin_domain: admin_domain, provider_key: provider_key) }

  context '#list_services' do
    it { expect(subject.list_services.length).to be >= 1 }
  end

  context '#get_service' do
    it { expect(subject.show_service(service_id)).to be }
  end
end
