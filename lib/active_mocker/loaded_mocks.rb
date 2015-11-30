module ActiveMocker
  class LoadedMocks
    class << self

      extend Forwardable
      def_delegators :mocks, :find, :delete_all

      # Returns an Enumerable of all currently loaded mocks.
      #
      #   ActiveMocker::LoadedMocks.mocks
      #       => <Collection @hash: {'Person' => PersonMock}>
      # @return ActiveMocker::LoadedMocks::Collection
      def mocks
        Collection.new(mocks_store.values.each_with_object({}) do |mock_constant, hash|
                         hash[mock_constant.send(:mocked_class)] = mock_constant
                       end)
      end

      # @deprecated Use {#mocks} instead of this method.
      alias_method :class_name_to_mock, :mocks

      # @deprecated Use {#mocks} instead of this method.
      alias_method :all, :mocks

      # @deprecated Use {#delete_all} instead of this method.
      alias_method :clear_all, :delete_all

      class Collection

        include Enumerable

        # @option opts [Hash] hash
        def initialize(hash={})
          @hash = Hash[hash]
        end

        extend Forwardable
        def_delegators :hash, :[]=, :[], :each, :to_hash, :to_h

        # Calls {#delete_all} for all mocks globally, which removes all records that were saved or created.
        # @return [NilClass]
        def delete_all
          mocks.each(&__method__)
        end

        # @param [Array<Symbol, String, ActiveMocker::Mock>] args an array of ActiveRecord Model Names as Strings or Symbols
        # or of mock object.
        # @return [ActiveMocker::LoadedMocks::Collection] returns ActiveMock equivalent class.
        def slice(*args)
          self.class.new(select { |k, v| get_item(args, k, v) })
        end

        # Input ActiveRecord Model Name as String or Symbol and it returns everything but that ActiveMock equivalent class.
        #    except('User') => [AccountMock, OtherMock]
        # @param [Array<Symbol, String, ActiveMocker::Mock>] args
        # @return ActiveMocker::LoadedMocks::Collection
        def except(*args)
          self.class.new(reject { |k, v| get_item(args, k, v) })
        end

        # Input ActiveRecord Model Name as String or Symbol returns ActiveMock equivalent class.
        #    find('User') => UserMock
        # @param [Symbol, String, ActiveMocker::Mock] item
        # @return ActiveMocker::Mock
        def find(item)
          slice(item).mocks.first
        end

        # @return [Array<ActiveMocker::Mock>]
        def mocks
          hash.values
        end
        alias_method :values, :mocks

        private
        attr_reader :hash

        def get_item(args, k, v)
          args.map do |e|
            if [:to_str, :to_sym].any?{|i| e.respond_to? i}
              e.to_s == k
            else
              e == v
            end
          end.any? { |a| a }
        end

      end

      private

      def mocks_store
        @mocks ||= {}
      end

      def add(mocks_to_add)
        mocks_store.merge!({ mocks_to_add.name => mocks_to_add })
      end

    end
  end
end
