# frozen_string_literal: true

require 'three_scale_api'
require 'securerandom'
require_relative './spec_helper'

RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'Shared initialization', shared_context: :metadata do
  # Initial setup
  #
  # Before all test cases, acquire all the env. variables
  # Creates random name for resource (@name).
  # Creates instance of the API Client

  before(:all) do
    @endpoint = ENV.fetch('ENDPOINT')
    @provider_key = ENV.fetch('PROVIDER_KEY')
    log_level = ENV.fetch('THREESCALE_LOG', 'info')
    @name = SecureRandom.uuid
    @client = ThreeScaleApi::Client.new(endpoint: @endpoint,
                                        provider_key: @provider_key,
                                        log_level: log_level)
    @resource = nil
    @manager = nil
  end

  RSpec::Matchers.define :res_include do |expected|
    match do |actual|
      if actual.is_a?(Hash)
        expect(actual).to include(expected)
      else
        expect(actual.entity).to include(expected)
      end
    end
  end

  let(:random_gen_name) { SecureRandom.uuid }

  ##############################
  ###                        ###
  ### Shared methods section ###
  ###                        ###
  ##############################

  # Creates ad_hoc service
  #
  # @param [String] name Service name, if not provided, uses default
  # @param [Hash] params Additional parameters
  def create_service(name: nil, **params)
    name ||= @name
    @client.services.create(name: name, system_name: name, **params)
  end

  # Creates account with fixed default acc. plan
  #
  # @param [String] name Account name, if not provided, uses default
  # @param [Hash] params Additional parameters
  def create_account(name: nil, **params)
    name ||= @name
    fix_default_acc_plan
    @client.accounts.sign_up(org_name: name, username: name, **params)
  end

  # Creates provider
  #
  # @param [String] name Provider name, if not provided, uses default
  # @param [Hash] params Additional parameters
  def create_provider(name: nil, **params)
    name ||= @name
    email = "#{name}@example.com"
    args = { username: name, email: email, password: name }.merge(**params)
    @client.providers.create(args)
  end

  # Creates active docs
  #
  # @param [String] name Active docs name, if not provided, uses default
  # @param [Hash] params Additional parameters
  def create_active_doc(name: nil, **params)
    name ||= @name
    args = { name: name, body: '{}',
             published: false,
             skip_swagger_validations: true }.merge(params)
    @resource = @manager.create(args)
  end

  # Cleans resource
  #
  # @param [DefaultResource] resource that will be cleaned
  def clean_resource(resource)
    resource&.delete # if resource exists, delete it
  rescue ThreeScaleApi::HttpClient::NotFoundError => ex
    @client.http_client.log.warning("Cannot delete #{resource}: #{ex}")
  end

  # Fixes default account plan
  #
  # This method fixes default account plan, if there is no default account plan,
  # it creates new with name Default (if it not exists). Then sets it to default
  # This is little workaround, because account plans will be soon removed.
  def fix_default_acc_plan
    acc_plan_manager = @client.account_plans
    acc_plan_def = acc_plan_manager['Default']
    acc_plan_manager.create(name: 'Default').set_default unless acc_plan_def
  end
end

# Rspec configuration, to include shared context
RSpec.configure do |rspec|
  rspec.include_context 'Shared initialization', include_shared: true
end
