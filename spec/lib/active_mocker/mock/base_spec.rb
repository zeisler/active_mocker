require 'spec_helper'
require 'logger'
require 'active_mocker/mock'
require_relative 'queriable_shared_example'
describe ActiveMocker::Mock::Base do

  class ActiveMocker::Mock::Base
    class << self

      def abstract_class?
        false
      end

      def records=(r)
        @records = r
      end
    end

    def id
      self.class.attributes[:id]
    end

    def id=(val)
      self.class.attributes[:id] = val
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
  
  before do
    described_class.clear_mock
  end

  after do
    described_class.clear_mock
  end

end