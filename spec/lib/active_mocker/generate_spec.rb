require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker'
require_relative '../../unit_logger'

describe ActiveMocker::Generate do

  let(:app_root){ File.expand_path('../../../../', __FILE__)}
  let(:mock_dir){ File.join(app_root, 'sample_app_rails_4/spec/mocks')}

  before(:each) do
    ActiveMocker.config do |config|
      config.schema_file = File.join(app_root, 'sample_app_rails_4/db/schema.rb')
      config.model_dir   = File.join(app_root, 'sample_app_rails_4/app/models')
      config.mock_dir    = mock_dir
      config.logger      = UnitLogger
    end

    FileUtils.rm_rf mock_dir

  end

  subject{described_class.new(silence: true)}

  describe 'new' do

    before(:each) do
      subject
    end

    it 'generates all mocks files' do
      expect(File.exist? File.join(mock_dir, 'user_mock.rb')        ).to eq true
      expect(File.exist? File.join(mock_dir, 'micropost_mock.rb')   ).to eq true
      expect(File.exist? File.join(mock_dir, 'relationship_mock.rb')).to eq true
    end

  end

end

