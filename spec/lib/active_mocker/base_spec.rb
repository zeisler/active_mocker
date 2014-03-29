require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/base'
require 'active_support/all'

describe ActiveMocker::Base do

  let(:subject){ described_class.new('Model', File.expand_path('../../', __FILE__), {file_input: file_input}) }

  before do

    class StringInput

      def initialize(class_string)
        @class_string = class_string
      end

      def open(*args)
        self
      end

      def read
        @class_string
      end

    end

  end

  let(:mock_class){subject.mock_class}

  describe '#mock_class' do

    let(:file_input){
      StringInput.new <<-eos
        class Model < ActiveRecord::Base
        end
      eos
    }

    it 'create a mock object after the active record' do
      expect(subject.mock_class).to eq(ModelMock)
    end

    context 'private methods' do

      let(:file_input){
        StringInput.new <<-eos
        class Model < ActiveRecord::Base
          private

          def bar
          end

        end
        eos
      }

      it 'will not have private methods' do
        expect{mock_class.bar}.to raise_error(NoMethodError)
      end

    end

    describe '#mock_of' do

      it 'return the name of the class that is being mocked' do
        expect(mock_class.new.mock_of).to eq 'Model'
      end

    end

    describe 'instance methods' do

      let(:file_input){
        StringInput.new <<-eos
        class Model < ActiveRecord::Base
          def foo
          end
        end
        eos
      }

      it 'will raise exception for unimplemented methods' do
        expect{mock_class.new.foo}.to raise_error('#foo is not Implemented for Class: ModelMock')
      end

      it 'can be implemented dynamically' do
        mock_class.instance_eval do
          define_method(:foo) do
            'Now implemented'
          end
        end

        expect(mock_class.new.foo).to eq "Now implemented"

      end

      it 'can be implemented by reopening the class' do
        instance = mock_class.new
        #class must be created first before redefining methods
        class ModelMock
          def foo
            'Now implemented'
          end
        end

        expect(instance.foo).to eq "Now implemented"

      end

    end

    describe 'class methods' do

      let(:file_input){
        StringInput.new <<-eos
        class Model < ActiveRecord::Base
          scope :named, -> { }

          def self.class_method
          end
        end
        eos
      }

      it 'will raise exception for unimplemented methods' do
        expect{mock_class.class_method}.to raise_error('::class_method is not Implemented for Class: ModelMock')
      end

      it 'can be implemented as follows' do
        mock_class.singleton_class.class_eval do
          define_method(:named) do
            'Now implemented'
          end
        end

        expect(mock_class.named).to eq "Now implemented"

      end

      it 'loads named scopes as class method' do
        expect{mock_class.named}.to raise_error('::named is not Implemented for Class: ModelMock')
      end

    end

  end

  describe 'will read class from file' do

    let(:subject){ described_class.new('Model', File.expand_path('../../', __FILE__)) }

    it '#mock_class' do
      expect(subject.mock_class).to eq(ModelMock)
    end
  end

  describe 'have attributes from schema' do

    xit 'uses ActiveHash'

    xit 'makes plain ruby class' do

    end

  end

end
