module ActiveMocker

  class LoadedMocks
    
    class << self

      def add(mocks_to_add)
        mocks.merge!({mocks_to_add.name => mocks_to_add})
      end

      def add_subclass(subclass)
        subclasses.merge!({subclass.mocked_class => subclass})
      end

      def subclasses
        @subclasses ||= {}
      end

      def clear_subclasses
        subclasses.clear
      end

      def mocks
        @mocks ||= {}
      end

      def find(klass)
        class_name_to_mock[klass]
      end

      def all
        mocks
      end

      def clear_all
        all_mocks.each { |m| m.clear_mock }
        clear_subclasses
      end

      def delete_all
        all_mocks.each { |m| m.delete_all }
      end

      def reload_all
        all_mocks.each { |m| m.send(:reload) }
      end

      def undefine_all
        all_mocks_as_str.each do |n|
          Object.send(:remove_const, n) if Object.const_defined?(n)
        end
      end

      def all_mocks_as_str
        mocks.keys + subclasses.keys
      end

      def class_name_to_mock
        hash = mocks.values.each_with_object({}) do |mock_constant, hash|
          hash[mock_constant.mocked_class] = mock_constant
        end
        hash.merge(subclasses)
      end

      private

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
