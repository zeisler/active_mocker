module ActiveMocker

  class LoadedMocks
    
    class << self

      # Input ActiveRecord Model as String returns ActiveMock equivalent class.
      #   +find('User')+ => UserMock
      def find(klass)
        class_name_to_mock[klass]
      end

      # Returns Hash key being a string of the active_record class name
      # and the value being the mocked class.
      #   ActiveMocker::LoadedMocks.all
      #      => {'PersonMock' => PersonMock}
      def all
        mocks
      end

      # Calls clear_all for all mocks, which deletes all saved records and removes mock_class/instance_method.
      #   It will also clear any sub classed mocks from the list
      #   Method will be deprecated in v2 because mocking is deprecated
      def clear_all
        all_mocks.each { |m| m.clear_mock }
        clear_subclasses
      end

      # Calls delete_all for all mocks, which deletes all saved records.
      #
      def delete_all
        all_mocks.each { |m| m.delete_all }
      end

      # Returns Hash +{"ActiveRecordModel" => MockVersion}+, key being a string of the active_record class name
      # and the value being the mocked class. Any sub classed mocked will override the original mock until clear_all is called.
      #
      #   ActiveMocker::LoadedMocks.class_name_to_mock
      #       => {'Person' => PersonMock}
      def class_name_to_mock
        mocks.values.each_with_object({}) do |mock_constant, hash|
          hash[mock_constant.send(:mocked_class)] = mock_constant
        end.merge(subclasses)
      end

      private

      def add(mocks_to_add)
        mocks.merge!({mocks_to_add.name => mocks_to_add})
      end

      def add_subclass(subclass)
        subclasses.merge!({subclass.send(:mocked_class) => subclass})
      end

      def mocks
        @mocks ||= {}
      end

      def undefine_all
        all_mocks_as_str.each do |n|
          Object.send(:remove_const, n) if Object.const_defined?(n)
        end
      end

      def all_mocks_as_str
        mocks.keys + subclasses.keys
      end

      def subclasses
        @subclasses ||= {}
      end

      def clear_subclasses
        subclasses.clear
      end

      def internal_clear
        clear_subclasses
        mocks.clear
      end

      def all_mocks
        mocks.values + subclasses.values
      end
      
    end
   
  end

end
