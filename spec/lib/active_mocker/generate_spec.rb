require 'spec_helper'
require 'active_mocker'
require 'spec/unit_logger'
require 'active_mocker/string_reader'

describe ActiveMocker::Generate do

  let(:app_root){ File.expand_path('../../../../', __FILE__)}
  let(:mock_dir){ File.join(app_root, 'test_rails_4_app/spec/mocks')}

  describe 'rake active_mocker:build' do

    before(:each) do
      `cd test_rails_4_app && bundle exec rake active_mocker:build`
    end

    it 'generates all mocks files' do
      expect(File.exist? File.join(mock_dir, 'user_mock.rb')        ).to eq true
      expect(File.exist? File.join(mock_dir, 'micropost_mock.rb')   ).to eq true
      expect(File.exist? File.join(mock_dir, 'relationship_mock.rb')).to eq true
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
        config.mock_dir           = File.join(mock_dir, 'spec/mocks')
        config.logger             = Logger.new(string_log)
        config.file_reader        = ActiveMocker::StringReader.new(failing_model)
      end
    end

    it do
      allow_any_instance_of(ActiveMocker::ModelSchema::Assemble).to receive(:models){['model']}
      output = capture(:stdout) {described_class.new(silence: true)}
      expect(output).to eq "1 mock(s) out of 1 failed. See log for more info.\n"
      expect(string_log.string).to match /Error loading Model: model/
      expect(string_log.string).to match /uninitialized constant/
      expect(string_log.string).to match /model.rb:3:in `<module:BlowUp>'/
    end

  end

end