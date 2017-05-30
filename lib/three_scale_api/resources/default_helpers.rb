# frozen_string_literal: true

require 'three_scale_api/resources/default'

module ThreeScaleApi
  module Resources
    ########################
    ##                    ##
    ##   Plans helpers    ##
    ##                    ##
    ########################

    # Default plan resource manager wrapper
    class DefaultPlanManager < DefaultManager
      # @api public
      # Creates instance of the Default plan manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client, entity_name: nil, collection_name: nil)
        super(http_client, entity_name: entity_name, collection_name: collection_name)
        @resource_instance = DefaultPlanResource
      end

      # @api public
      # Lists all plans
      #
      # @return [Array<DefaultPlan>] List of DefaultPlans
      def list_all(path = nil)
        @log.info("List all #{resource_name}s")
        response = @http_client.get(path)
        log_result resource_list(response)
      end

      # @api public
      # Sets global default plan
      #
      # @param [Fixnum] id Plan ID
      # @return [DefaultPlanResource] DefaultPlan plan instance
      def set_default(id)
        @log.debug("Set default #{resource_name}: #{id}")
        response = @http_client.put("#{base_path}/#{id}/default")
        log_result resource_instance(response)
      end

      # @api public
      # Gets global default plan
      #
      # @return [DefaultPlanResource] Default plan plan instance
      def get_default
        @log.info("Get default #{resource_name}:")
        result = nil
        _list.each do |plan|
          result = plan if plan['default']
        end
        log_result result
      end
    end

    # Account resource wrapper for account entity received by REST API
    class DefaultPlanResource < DefaultResource
      # Creates instance of the Default plan resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountPlanManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end

      # @api public
      # Sets plan as default
      def set_default
        @manager.set_default(entity['id']) if @manager.respond_to?(:set_default)
      end
    end

    ########################
    ##                    ##
    ## Set state helpers  ##
    ##                    ##
    ########################

    # Default state resource manager wrapper for default entity received by REST API
    class DefaultStateManager < DefaultManager
      # @api public
      # Creates instance of the state resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client, entity_name: nil, collection_name: nil)
        super(http_client, entity_name: entity_name, collection_name: collection_name)
        @resource_instance = DefaultStateResource
      end

      # @api public
      # Sets account to spec. state
      #
      # @param [Fixnum] id Account ID
      # @param [String] state 'approve' or 'reject' or 'make_pending'
      def set_state(id, state = 'approve')
        @log.info "Set state [#{id}]: #{state}"
        response = http_client.put("#{base_path}/#{id}/#{state}")
        log_result resource_instance(response)
      end
    end

    # Default resource wrapper for any entity received by REST API
    class DefaultStateResource < DefaultResource
      # @api public
      # Creates instance of the Default state resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end

      # @api public
      # Sets state of the account
      #
      # @param [String] state 'approve' or 'reject' or 'make_pending'
      def set_state(state)
        @manager.set_state(@entity['id'], state) if @manager.respond_to?(:set_state)
      end
    end

    ########################
    ##                    ##
    ##   Users helpers    ##
    ##                    ##
    ########################

    # Default user resource manager wrapper for default entity received by REST API
    class DefaultUserManager < DefaultStateManager
      # @api public
      # Creates instance of the user resource manager
      #
      # @param [ThreeScaleQE::TestClient] http_client Instance of http client
      def initialize(http_client)
        super(http_client, entity_name: 'user', collection_name: 'users')
        @resource_instance = DefaultUserResource
      end

      # @api public
      # Suspends the user
      #
      # @param [Fixnum] id User ID
      def suspend(id)
        set_state(id, state: 'suspend')
      end

      # @api public
      # Resumes the user
      #
      # @param [Fixnum] id User ID
      def resume(id)
        set_state(id, state: 'unsuspend')
      end

      # @api public
      # Resumes the user
      #
      # @param [Fixnum] id User ID
      def activate(id)
        set_state(id, state: 'activate')
      end

      # @api public
      # Sets role as admin
      #
      # @param [Fixnum] id User ID
      def set_as_admin(id)
        set_state(id, state: 'admin')
      end

      # @api public
      # Sets role as member
      #
      # @param [Fixnum] id User ID
      def set_as_member(id)
        set_state(id, state: 'admin')
      end
    end

    # Default user wrapper for any entity received by REST API
    class DefaultUserResource < DefaultStateResource
      # @api public
      # Creates instance of the Default user resource
      #
      # @param [ThreeScaleQE::TestClient] client Instance of the test client
      # @param [AccountManager] manager Instance of the manager
      # @param [Hash] entity Service Hash from API client
      def initialize(client, manager, entity)
        super(client, manager, entity)
      end

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
