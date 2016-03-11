RSpec.describe 'Service API', type: :integration do

  let(:admin_domain) { ENV.fetch('ADMIN_DOMAIN') }
  let(:provider_key) { ENV.fetch('PROVIDER_KEY') }
  let(:service_id)   { ENV.fetch('SERVICE_ID') }
  let(:metric_id)   { ENV.fetch('METRIC_ID') }

  subject!(:client) { ThreeScale::API.new(admin_domain: admin_domain, provider_key: provider_key) }

  context '#list_services' do
    it { expect(subject.list_services.length).to be >= 1 }
  end

  context '#get_service' do
    it { expect(subject.show_service(service_id)).to be }
  end

  context '#create_service' do
    let(:name) { SecureRandom.uuid }
    it { expect(subject.create_service('name' => name)).to include('name' => name) }
  end

  context '#list_metrics' do
    it { expect(subject.list_metrics(service_id).length).to be >= 1 }
  end

  context '#create_metric' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(subject.create_metric(service_id, 'friendly_name' => name, 'unit' => 'foo'))
        .to include('friendly_name' => name, 'unit' => 'foo',
                    'name' => name.tr('-', '_'), 'system_name' =>name.tr('-', '_') )
    end
  end

  context '#list_methods' do
    it { expect(subject.list_methods(service_id, metric_id).length).to be >= 1 }
  end

  context '#create_method' do
    let(:name) { SecureRandom.uuid }

    it do
      expect(subject.create_method(service_id, metric_id, 'friendly_name' => name, 'unit' => 'bar'))
          .to include('friendly_name' => name, # no unit
                      'name' => name.tr('-', '_'), 'system_name' =>name.tr('-', '_') )
    end
  end
end
