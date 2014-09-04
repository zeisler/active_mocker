require 'spec_helper'
require 'logger'
require 'active_mocker/config'
require 'active_mocker/file_reader'

describe ActiveMocker::Config do

  after do
    described_class.reset_all
    described_class.load_defaults
  end

  before do
    described_class.reset_all
    described_class.load_defaults
  end

  describe 'model_base_classes' do

    it 'can be set and persisted' do
      expect(described_class.model_base_classes).to eq %w[ActiveRecord::Base]
      described_class.model_base_classes = %w[BaseClass]
    end

  end

  describe 'file_reader' do

    it 'will set a default' do
      expect(described_class.file_reader).to eq ActiveMocker::FileReader
    end

  end

end