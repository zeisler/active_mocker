require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'singleton'
require 'logger'
require 'forwardable'
require 'active_mocker/logger'
require 'string_reader'
require 'active_mocker/public_methods'
require 'file_reader'
require 'active_mocker/collection_association'
require 'active_mocker/table'
require 'active_mocker/config'
require 'active_mocker/reparameterize'
require 'active_mocker/field'
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/schema_reader'
require 'active_mocker/active_record/schema'
require 'active_support/all'
require 'active_hash/ar_api'
require 'active_mocker/generate'
require 'erb'
require 'virtus'
require_relative '../../unit_logger'

describe ActiveMocker::Generate do

  before(:each) do
    app_root = File.expand_path('../../../../', __FILE__)
    ActiveMocker.config do |config|
      # Required Options
      config.schema_file = File.join(app_root, 'sample_app_rails_4/db/schema.rb')
      config.model_dir   = File.join(app_root, 'sample_app_rails_4/app/models')
      config.mock_dir    = File.join(app_root, 'sample_app_rails_4/spec/mocks')
      config.logger = UnitLogger

    end

  end

  describe 'new' do

    it 'generates all mocks' do

      described_class.new

    end

  end

end