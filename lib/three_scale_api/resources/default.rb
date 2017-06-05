# frozen_string_literal: true

require 'three_scale_api/tools'
require 'three_scale_api/resources/default'

module ThreeScaleApi
  # Main module containing implementation of the resources and it's managers
  module Resources
    # Default resource wrapper for any entity received by REST API
    # All other resources inherits from Default resource
    class DefaultResource
      attr_accessor :http_client,
                    :manager,
                    :api,
                    :entity_id

      # @api public
      # Constructs the resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [ThreeScaleApi::Clients::DefaultClient] manager Instance of test client
      # @param [Hash] entity Entity Hash from API client
      def initialize(client, manager, entity: nil, entity_id: nil)
        @http_client = client
        @entity = entity
        @manager = manager
        @entity_id = entity_id
        @entity_id ||= entity['id'] if entity
      end

      # Lazy load entity
      def entity
        read unless @entity
        @entity
      end

      # @api public
      # Access properties of the resource contained in the entity
      #
      # @param [String] key Name of the property
      # @return [object] Value of the property
      def [](key)
        entity[key]
      end

      # @api public
      # Set property value of the resource contained in the entity
      #
      # @param [String] key Name of the property
      # @param [String] value Value of the property
      # @return [object] Value of the property
      def []=(key, value)
        entity[key] = value
      end

      # @api public
      # Deletes Resource if possible (method is implemented in the manager)
      def delete
        return false unless @entity_id
        @manager.delete(@entity_id) if @manager.respond_to?(:delete)
      end

      # @api public
      # Updates Resource if possible (method is implemented in the manager)
      #
      # @return [DefaultEntity] Updated entity
      def update
        @manager.update(entity) if @manager.respond_to?(:update)
      end

      # @api public
      # Reloads entity from remote server if possible
      #
      # @return [DefaultEntity] Entity
      def read
        return nil unless @manager.respond_to?(:read)
        ent = @manager.read(@entity_id)
        @entity = ent.entity
      end

      # @api public
      # Converts to string
      #
      # @return [String] String representation of the resource
      def to_s
        entity.to_s
      end

      # Wrapper to create manager instance
      #
      # @param [Class<DefaultClient>] which Manager which instance will be created
      # @param [Array<Symbol>] args Optional arguments
      # @return [DefaultClient] Instance of the specific manager
      def manager_instance(which, *args)
        manager = Clients.const_get "#{which}Client"
        manager.new(@http_client, self, *args) if manager.respond_to?(:new)
      end

      # Respond to method missing
      #
      # If symbol is not defined in current class, it will be forwarded to entity hash
      # @param [Symbol, String] symbol Method name
      # @return [Bool] true if responds, false otherwise
      def respond_to_missing?(symbol, *_)
        entity.respond_to?(symbol) || entity.key?(symbol)
      end

      # Method missing implementation
      #
      # @param [Symbol, String] symbol Method name
      # @param [Array] args Arguments passed to method
      # @param [Block] block Block passed to method
      def method_missing(symbol, *args, &block)
        if entity.key?(symbol)
          entity[symbol]
        elsif entity.respond_to?(symbol)
          entity.send(symbol, *args, &block)
        else
          super
        end
      end

      # @api public
      # Converts resource to hash
      #
      # @return [Hash] Entity hash
      def to_h
        entity
      end
    end

    # Account resource wrapper for account entity received by REST API
    module DefaultPlanResource
      # @api public
      # Sets plan as default
      def set_default
        @manager.set_default(@entity_id) if @manager.respond_to?(:set_default)
      end
    end

    # Default resource wrapper for any entity received by REST API
    module DefaultStateResource
      # @api public
      # Sets state of the account
      #
      # @param [String] state 'approve' or 'reject' or 'make_pending'
      def set_state(state)
        @manager.set_state(@entity_id, state) if @manager.respond_to?(:set_state)
      end
    end

    # Default user wrapper for any entity received by REST API
    module DefaultUserResource
      include DefaultStateResource
      # @api public
      # Activate user's account
      def activate
        set_state('activate')
      end

      # @api public
      # Suspend user's account
      def suspend
        set_state('suspend')
      end

      # @api public
      # Resume user's account
      def resume
        set_state('unsuspend')
      end

      # @api public
      # Set user as admin
      def as_admin
        set_state('admin')
      end

      # @api public
      # Set user as member
      def as_member
        set_state('member')
      end
    end
  end
end
