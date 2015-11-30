require 'rails_helper'
require 'rake'

describe "rake active_mocker:build" do
  before { SampleApp::Application.load_tasks }
  it "builds the mocks from the model dir" do
    ENV["MUTE_PROGRESS_BAR"] = "true"
    ENV["ERROR_VERBOSITY"] = "0"
    Rake::Task["active_mocker:build"].invoke
    mock_dir = Rails.root.join('spec/mocks')
    expect(File.exist? mock_dir                                   ).to eq true
    expect(File.exist? File.join(mock_dir, 'user_mock.rb')        ).to eq true
    expect(File.exist? File.join(mock_dir, 'micropost_mock.rb')   ).to eq true
    expect(File.exist? File.join(mock_dir, 'relationship_mock.rb')).to eq true
    expect(File.exist? File.join(mock_dir, 'nacis_mock.rb')).to eq false
  end
end

