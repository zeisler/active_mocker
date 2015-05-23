module ActiveMocker
  class LoadedMocks
    class << self
      attr_writer :disable_global_state

      def disable_global_state
        @@disable_global_state ||= true
      end
      # Input ActiveRecord Model Name as String or Symbol returns ActiveMock equivalent class.
      #   +find('User')+ => UserMock
      def find(klass)
        class_name_to_mock.find(klass)
      end

      # Calls #delete_all for all mocks globally, which removes all records that were saved or created.
      def delete_all
        all_mocks.each do |mock|
          mock.send(__method__)
        end
      end

      alias_method :clear_all, :delete_all

      # Returns an Enumerable of all currently loaded mocks. The key is a string of the active_record class name and
      # the value being the mocked class.
      #
      #   ActiveMocker::LoadedMocks.class_name_to_mock
      #       => <Collection @hash: {'Person' => PersonMock}>
      def class_name_to_mock
        Collection.new(mocks.values.each_with_object({}) do |mock_constant, hash|
                         hash[mock_constant.send(:mocked_class)] = mock_constant
                       end)
      end

      alias_method :all, :class_name_to_mock

      # Returns an Enumerable where the key is a string of the active_record class name and the value being the mocked
      # class. Given a unique hash key it creates a unique set of mocks from the mocks that are loaded. The new mocks
      # inherits from the loaded mock in order to create a unique record set.
      #
      #   ActiveMocker::LoadedMocks.scoped_set('Ab12nairaa3i')
      #       => <Collection @hash: {'Person' => PersonMockAb12nairaa3i}>
      def scoped_set(uniq_key)
        return Collection.new(class_name_to_mock) if !disable_global_state || uniq_key.nil?
        create_scoped_set(uniq_key) unless const_defined?(key_to_module_name(uniq_key))
        scoped_set_hash[key_to_module_name(uniq_key).constantize]
      end

      # To remove the references created from +#scoped_set+. Allowing GC to clean up uniquely created mocks.
      def deallocate_scoped_set(uniq_key)
        klass = key_to_module_name(uniq_key).constantize
        scoped_set_hash.delete(klass)
        Object.send(:remove_const, key_to_module_name(uniq_key))
      end

      class Collection

        include Enumerable

        def initialize(hash={})
          @hash = Hash[hash]
        end

        extend Forwardable
        def_delegators :hash, :[]=, :[], :each, :to_hash, :to_h

        def delete_all
          mocks.map(&:delete_all)
        end

        def valid?(parent_collection)
          hash.count == parent_collection.count
        end

        def mocks
          hash.values
        end

        alias_method :values, :mocks

        def slice(*args)
          self.class.new(select { |k, v| get_item(args, k, v) })
        end

        def except(*args)
          self.class.new(reject { |k, v| get_item(args, k, v) })
        end

        def find(item)
          slice(item).mocks.first
        end

        private
        attr_reader :hash

        def get_item(args, k, v)
          args.map do |e|
            if e.respond_to? :_uniq_key_for_record_context
              e == v
            else
              e.to_s == k
            end
          end.any? { |a| a }
        end

      end

      private

      def create_scoped_set(uniq_key)
        return Collection.new(class_name_to_mock) if uniq_key.nil?
        outer_module = get_or_create_module(key_to_module_name(uniq_key))
        class_name_to_mock.each_with_object(scoped_set_hash[outer_module] = Collection.new) do |(class_name, mock), col|
          col[class_name] ||= add_uniq_key_method(outer_module.const_set(class_name.camelcase, Class.new(mock)), uniq_key)
        end
      end

      def get_or_create_module(module_name)
        unless const_defined?(module_name)
          Object.const_set(module_name, Module.new)
        else
          module_name.constantize
        end
      end

      def key_to_module_name(uniq_key)
        'A' + trim_key(uniq_key).camelcase
      end

      def trim_key(uniq_key)
        return nil if uniq_key.nil?
        uniq_key[0..10]
      end

      def add_uniq_key_method(klass, uniq_key)
        klass.send(:attr_reader, :_uniq_key_for_record_context)

        def klass._uniq_key_for_record_context(value: @_uniq_key_for_record_context)
          @_uniq_key_for_record_context = value
        end

        klass._uniq_key_for_record_context(value: uniq_key)
        klass
      end

      def add(mocks_to_add)
        mocks.merge!({ mocks_to_add.name => mocks_to_add })
      end

      def mocks
        @mocks ||= {}
      end

      def scoped_set_hash
        @scoped_set ||= {}
      end

      def internal_clear
        mocks.clear
        scoped_set_hash.clear
      end

      def all_mocks
        (mocks.values + scoped_set_hash.try { values.try { compact.map(&:mocks) }.flatten }).compact
      end

    end
  end
end
