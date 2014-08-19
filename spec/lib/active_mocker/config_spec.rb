require 'spec_helper'
require 'logger'
require 'active_mocker/config'
require 'active_mocker/file_reader'

describe ActiveMocker::Config do

  after do
    described_class.clear_settings
  end

  before do
    described_class.clear_settings
  end

  let(:set_defaults){
    stub_const('Rails', double(root: ''))
    described_class.set do |config|
      config.schema_file = File.join(Rails.root, 'db/schema.rb')
      config.model_dir = File.join(Rails.root, 'app/models')
      config.mock_dir = File.join(Rails.root, 'spec/mocks')
      config.model_base_classes = %w[ ActiveRecord::Base ]
    end
  }

  describe 'model_base_classes' do

    it 'can be set and persisted' do
      set_defaults
      expect(described_class.model_base_classes).to eq %w[ActiveRecord::Base]
      described_class.model_base_classes = %w[BaseClass]
    end

  end

  describe 'file_reader' do

    it 'will set a default' do
      set_defaults
      expect(described_class.file_reader).to eq ActiveMocker::FileReader
    end

  end

  describe 'will not reset defaults when already set' do

    it do
      set_defaults
      described_class.set do |config|
        config.schema_file = 'schema.rb'
      end

      expect(described_class.schema_file).to eq 'schema.rb'
      expect(described_class.model_dir).to eq '/app/models'
    end

  end

  describe 'will raise error if setting not set' do

    it do
      expect{described_class.set do |config|
        config.schema_file = 'schema.rb'
      end}.to raise_error 'ActiveMocker::Config #model_dir must be specified!'
    end

  end

end