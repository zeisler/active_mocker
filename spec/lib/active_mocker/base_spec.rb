require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)

require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/base'
require 'active_support/all'

describe ActiveMocker::Base do

  let(:subject){ described_class.new('Model', File.expand_path('../../', __FILE__)) }

  let(:mock_class){subject.mock_class}

  describe '#mock_class' do

    it 'create a mock object after the active record' do
      expect(subject.mock_class).to eq(ModelMock)
    end

    describe '#mock_of' do

      it 'return the name of the class that is being mocked' do
        expect(mock_class.new.mock_of).to eq 'Model'
      end

    end

    describe '#foo' do

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

    describe '::named' do

      it 'will raise exception for unimplemented methods' do
        expect{mock_class.named}.to raise_error('::named is not Implemented for Class: ModelMock')
      end

      it 'can be implemented as follows' do
        mock_class.singleton_class.class_eval do
          define_method(:named) do
            'Now implemented'
          end
        end

        expect(mock_class.named).to eq "Now implemented"

      end

    end

  end


end
