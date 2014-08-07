require 'rspec'
$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker'
require_relative '../../unit_logger'

describe ActiveMocker::Generate do

  let(:app_root){ File.expand_path('../../../../', __FILE__)}
  let(:mock_dir){ File.join(app_root, 'test_rails_4_app/spec/mocks')}

  describe 'new' do

    before(:each) do
      `cd test_rails_4_app && bundle exec rake active_mocker:build`
    end

    it 'generates all mocks files' do
      expect(File.exist? File.join(mock_dir, 'user_mock.rb')        ).to eq true
      expect(File.exist? File.join(mock_dir, 'micropost_mock.rb')   ).to eq true
      expect(File.exist? File.join(mock_dir, 'relationship_mock.rb')).to eq true
    end

  end

end

