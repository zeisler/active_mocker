require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/logger'

describe ActiveMocker::Logger do

  describe '::set' do

    let(:logger){double()}

    around do
      described_class.class_variable_set(:@@logger, nil)
    end

    it 'set the logger to be used by the mock class' do
      described_class.set(logger)
      expect(described_class.class_variable_get(:@@logger)).to eq(logger)
    end

    it 'will pass any methods to the set logger' do
      described_class.set(logger)
      expect(logger).to receive(:info)
      described_class.info
    end

    it 'will return nil if no logger is set' do
      expect(described_class.any_method).to eq nil
    end

  end

end