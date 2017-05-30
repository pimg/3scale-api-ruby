# frozen_string_literal: true

require 'three_scale_api/tools'

module ThreeScaleApi
  # Main module containing implementation of the resources and it's managers
  module Resources
    # Default resource manager wrapper for default entity received by REST API
    # All other managers inherits from Default manager
    class DefaultManager
      attr_accessor :http_client, :resource_instance, :log

      # @api public
      # Creates instance of the Default resource manager
      #
      # @param [ThreeScaleApi::HttpClient] http_client Instance of http client
      def initialize(http_client, entity_name: nil, collection_name: nil)
        @http_client = http_client
        @log = http_client.logger_factory.get_instance(name: manager_name)
        @resource_instance = DefaultResource
        @entity_name = entity_name
        @collection_name = collection_name
      end

      # @api public
      # Base path for the REST call
      #
      # @return [String] Base URL for the REST call
      def base_path
        +'/admin/api'
      end

      # @api public
      # Extracts Hash from response
      #
      # @param [String] collection Collection name
      # @param [String] entity Entity name
      # @param [object] from Response
      def extract(collection: nil, entity:, from:)
        from = from.fetch(collection) if collection

        case from
        when Array then from.map { |e| e.fetch(entity) }
        when Hash then from.fetch(entity) { from }
        when nil then nil # raise exception?
        else
          raise "unknown #{from}"
        end
      end

      # @api public
      # Access entity by it's ID or name
      #
      # @param [String,Fixnum] key Id or name of the entity
      # @return [DefaultResource] Requested entity
      def [](key)
        if key.is_a? Numeric
          read(key)
        else
          read_by_name(key)
        end
      end

      # @api public
      # Update entity
      #
      # @param [String,Fixnum] key id or name of the entity
      # @param [DefaultEntity] value Entity to be updated
      # @return [DefaultEntity] Updated entity
      def []=(key, value)
        id = if key.is_a? Numeric
               key
             else
               read_by_name(key)['id']
             end
        update(value, id: id)
      end

      # @api public
      # Creates entity
      #
      # @param [Hash] attributes Attributes for service to be created
      # @return [DefaultResource] Created resource
      def <<(attributes)
        create(attributes)
      end

      # Default method to list all the resources by manager
      #
      # @return [Array<DefaultResource>] The list of the Resources
      # @param [Hash] params optional arguments
      def list(params: {})
        @log.info("List #{resource_name}s")
        log_result _list(params: params)
      end

      # Default delete function
      def delete(id, params: {})
        @log.info("Delete #{resource_name}: #{id}")
        @http_client.delete("#{base_path}/#{id}", params: params)
        true
      end

      # @api public
      # Default read function
      #
      # @param [Fixnum] id Id of the entity
      # @return [DefaultResource] Instance of the default resource
      def read(id = nil)
        @log.info("Read #{resource_name}: #{id}")
        response = http_client.get("#{base_path}/#{id}")
        log_result resource_instance(response)
      end

      # @api public
      # Finds resource by it's system name
      #
      # @param [String] name System name
      # @return [DefaultResource] Resource instance
      def read_by_name(name)
        name = name.to_s
        find do |ent|
          ent['system_name'] == name || \
            ent['name'] == name || \
            ent['org_name'] == name || \
            ent['friendly_name'] == name || \
            ent['username'] == name || \
            ent['pattern'] == name
        end
      end

      # @api public
      # Finds resource by it's spec. attribute name
      #
      # @param [Hash] params Optional parameters
      # @param [Block] block Condition block
      # @return [DefaultResource] Resource instance
      def find(params: {}, &block)
        @log.info("Find #{resource_name}")
        resources = _list(params: params)
        log_result resources.find(&block)
      end

      # @api public
      # Selects resources by it's spec. conditions
      #
      # @param [Hash] params Optional parameters
      # @param [Block] block System name
      # @return [Array<DefaultResource>] Array of Resources instance
      def select(params: {}, &block)
        @log.info("Select #{resource_name}")
        resources = _list(params: params)
        log_result resources.select(&block)
      end

      # @api public
      # Creates new resource
      #
      # @param [Hash] attributes Attributes of the created object
      # @return [DefaultResource] Created resource
      def create(attributes)
        @log.info("Create #{resource_name}: #{attributes}")
        response = http_client.post(base_path, body: attributes)
        log_result resource_instance(response)
      end

      # @api public
      # Updates existing resource
      #
      # @param [Hash, DefaultResource] attributes Attributes that will be updated
      # @return [DefaultResource] Updated resource
      def update(attributes, id: nil)
        id ||= attributes['id']
        @log.info("Update [#{id}]: #{attributes}")
        response = http_client.put("#{base_path}/#{id}", body: attributes)
        log_result resource_instance(response)
      end

      # Internal list method method to list all the resources by manager
      #
      # @return [Array<DefaultResource>] The list of the Resources
      # @param [Hash] params optional arguments
      def _list(params: {})
        resource_list http_client.get(base_path, params: params)
      end

      # Wrapper to create instance of the Resource
      # Requires to have @resource_instance initialized to correct Resource subtype
      #
      # @param [Hash] entity Entity received from REST call using API
      # @return [DefaultResource] Specific instance of the resource
      def instance(entity)
        inst = {}
        res_inst = @resource_instance
        inst = res_inst.new(@http_client, self, entity) if res_inst.respond_to?(:new)
        instance_name = inst.class.name.split('::').last
        @log.debug("[RES] #{instance_name}: #{entity}")
        inst
      end

      # Wrap result of the call to the instance
      #
      # @param [object] response Response from server
      def resource_instance(response)
        result = extract(entity: @entity_name, from: response)
        instance(result)
      end

      # Wrap result array of the call to the instance
      #
      # @param [object] response Response from server
      def resource_list(response)
        result = extract(collection: @collection_name, entity: @entity_name, from: response)
        result.map { |res| instance(res) }
      end

      # Gets manager name for logging purposes
      #
      # @return [String] Manager name
      def manager_name
        self.class.name.split('::').last
      end

      # Gets resource name for specific manager
      #
      # @return [String] Manager name
      def resource_name
        manager = manager_name.dup
        manager['Manager'] = ''
        manager
      end

      # Logs result of the operation
      #
      # @param [DefaultEntity] result Result of the operation
      # @return [DefaultEntity] Returns the same entity
      def log_result(result)
        if result.is_a?(Array)
          @log.info(" #{resource_name}s: #{result.length}")
          result.each_with_index { |res, index| @log.info("\tItem #{index}: #{res}") }
        else
          @log.info(" --> Result: #{result}")
        end
        result
      end
    end

    # Default resource wrapper for any entity received by REST API
    # All other resources inherits from Default resource
    class DefaultResource
      attr_accessor :http_client,
                    :manager,
                    :api,
                    :entity

      # @api public
      # Constructs the resource
      #
      # @param [ThreeScaleApi::HttpClient] client Instance of http client
      # @param [ThreeScaleApi::Resources::DefaultManager] manager Instance of test client
      # @param [Hash] entity Entity Hash from API client
      def initialize(client, manager, entity)
        @http_client = client
        @entity = entity
        @manager = manager
      end

      # @api public
      # Access properties of the resource contained in the entity
      #
      # @param [String] key Name of the property
      # @return [object] Value of the property
      def [](key)
        return nil unless entity
        @entity[key]
      end

      # @api public
      # Set property value of the resource contained in the entity
      #
      # @param [String] key Name of the property
      # @param [String] value Value of the property
      # @return [object] Value of the property
      def []=(key, value)
        return nil unless entity
        @entity[key] = value
      end

      # @api public
      # Deletes Resource if possible (method is implemented in the manager)
      def delete
        return false unless @entity
        @manager.delete(@entity['id']) if @manager.respond_to?(:delete)
      end

      # @api public
      # Updates Resource if possible (method is implemented in the manager)
      #
      # @return [DefaultEntity] Updated entity
      def update
        return nil unless @entity
        @manager.update(@entity) if @manager.respond_to?(:update)
      end

      # @api public
      # Reloads entity from remote server if possible
      #
      # @return [DefaultEntity] Entity
      def read
        return nil unless entity
        return nil unless @manager.respond_to?(:read)
        ent = @manager.read(@entity['id'])
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
      # @param [Class<DefaultManager>] which Manager which instance will be created
      # @param [Array<Symbol>] args Optional arguments
      # @return [DefaultManager] Instance of the specific manager
      def manager_instance(which, *args)
        which.new(@http_client, self, *args) if which.respond_to?(:new)
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
        @entity
      end
    end
  end
end
