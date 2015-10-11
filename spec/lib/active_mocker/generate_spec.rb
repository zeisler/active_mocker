require 'spec_helper'
require 'active_mocker'
require 'spec/unit_logger'
require 'active_mocker/string_reader'
require 'active_mocker/output_capture'

describe ActiveMocker::Generate do

  let(:app_root){ File.expand_path('../../../../', __FILE__)}
  let(:mock_dir){ File.join(test_app_dir, 'spec/mocks')}
  let(:test_app_dir){ File.join(app_root, 'test_rails_4_app')}

  after(:all) do
    system('cd test_rails_4_app && bundle exec appraisal rake active_mocker:build 2>&1 >/dev/null')
  end

  describe 'rake active_mocker:build' do

    it 'generates all mocks files' do
      FileUtils.rm_rf mock_dir
      system('cd test_rails_4_app && bundle exec appraisal rake active_mocker:build 2>&1 >/dev/null')
      expect(File.exist? mock_dir                                   ).to eq true
      expect(File.exist? File.join(mock_dir, 'user_mock.rb')        ).to eq true
      expect(File.exist? File.join(mock_dir, 'micropost_mock.rb')   ).to eq true
      expect(File.exist? File.join(mock_dir, 'relationship_mock.rb')).to eq true
      expect(File.exist? File.join(mock_dir, 'nacis_mock.rb')).to eq true
    end

  end

  describe 'print number of failures' do

    let(:failing_model) do
      <<-RUBY
      class Model < ActiveRecord::Base

        module BlowUp
          include SomeThing
        end

        Include BlowUp

      end
      RUBY
    end

    let(:string_log) { StringIO.new }

    before do
      ActiveMocker.configure do |config|
        config.schema_file        = ''
        config.model_dir          = ''
        config.mock_dir           = mock_dir
        config.file_reader        = ActiveMocker::StringReader.new(failing_model)
      end
      allow(ActiveMocker::Config).to receive(:logger){Logger.new(string_log)}
    end

    it do
      allow_any_instance_of(ActiveMocker::ModelSchema::Assemble).to receive(:models){['model']}
      output = ActiveMocker::OutputCapture.capture(:stdout) {described_class.new(silence: true)}
      expect(output).to eq "1 mock(s) out of 1 failed. See `log/active_mocker.log` for more info.\n"
      expect(string_log.string).to match /Error loading Model: model/
      expect(string_log.string).to match /uninitialized constant/
      expect(string_log.string).to match /model.rb:3:in `<module:BlowUp>'/
    end

  end

  describe 'HasNoParentClass' do

    let(:failing_model) do
      <<-RUBY
      class Model
      end
      RUBY
    end

    let(:string_log) { StringIO.new }

    before do
      ActiveMocker.configure do |config|
        config.schema_file = ''
        config.model_dir   = ''
        config.mock_dir    = mock_dir
        config.file_reader = ActiveMocker::StringReader.new(failing_model)
      end
      allow(ActiveMocker::Config).to receive(:logger) { Logger.new(string_log) }
    end

    it do
      allow_any_instance_of(ActiveMocker::ModelSchema::Assemble).to receive(:models) { ['model'] }
      output = ActiveMocker::OutputCapture.capture(:stdout) { described_class.new(silence: true) }
      expect(output).to eq "1 mock(s) out of 1 failed. See `log/active_mocker.log` for more info.\n"
      expect(string_log.string).to match /HasNoParentClass/
    end

  end

  describe "ENV['MODEL']" do

    let(:string_log) { StringIO.new }

    before do
      ActiveMocker.configure do |config|
        config.schema_file = File.join(test_app_dir, 'db/schema.rb')
        config.model_dir   = File.join(test_app_dir, 'app/models')
        config.mock_dir    = mock_dir
        config.generate_for_mock = 'user'
      end
      allow(ActiveMocker::Config).to receive(:logger) { Logger.new(string_log) }
    end

    it 'it will not render mock because of rails dependence, but will limit the model count to 1' do
      output = ActiveMocker::OutputCapture.capture(:stdout) { described_class.new(silence: true) }
      expect(output).to eq "1 mock(s) out of 1 failed. See `log/active_mocker.log` for more info.\n"
    end

  end

  describe "Will raise error if mock_dir = nil" do

    let(:string_log) { StringIO.new }

    before do
      ActiveMocker.configure do |config|
        config.schema_file = nil
        config.model_dir   = nil
        config.mock_dir    = nil
        config.generate_for_mock = 'user'
      end
    end

    it do
      expect{ described_class.new(silence: true) }.to raise_error('ActiveMocker::Config.mock_dir is set to nil!')
    end

  end

end