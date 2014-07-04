require 'rspec'

$:.unshift File.expand_path('../../../../../lib/active_mocker/', __FILE__)
require 'logger'
require 'mock'
require_relative 'queriable_shared_example'
describe ActiveMocker::Mock::Base do

  class ActiveMocker::Mock::Base
    class << self
      def attributes
        {}
      end

      def types
        []
      end

      def associations
        []
      end

      def mocked_class
      end

      def attribute_names
      end

      def primary_key
      end

      def records=(r)
        @records = r
      end
    end

    def id
      self.class.attributes[:id]
    end

  end

  it_behaves_like 'Queriable', -> (*args) {
      ActiveMocker::Mock::Base.clear_mock
      ActiveMocker::Mock::Base.send(:records=, ActiveMocker::Mock::Records.new(args.flatten))
      ActiveMocker::Mock::Base
  }

  describe 'destroy' do

    subject{ described_class.create }

    it 'will delegate to delete' do
      subject.destroy
      expect(described_class.count).to eq 0
    end

  end

  after(:all) do
    described_class.clear_mock
  end

end