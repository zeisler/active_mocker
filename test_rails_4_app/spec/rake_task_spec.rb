require 'rails_helper'
require 'rake'

describe "rake active_mocker:build" do
  before { SampleApp::Application.load_tasks }
  it "builds the mocks from the model dir" do
    expect(File.exist? mock_path                                   ).to eq true
    expect(File.exist? File.join(mock_path, 'user_mock.rb')        ).to eq true
    expect(File.exist? File.join(mock_path, 'micropost_mock.rb')   ).to eq true
    expect(File.exist? File.join(mock_path, 'relationship_mock.rb')).to eq true
    expect(File.exist? File.join(mock_path, 'api/customer_mock.rb')).to eq true
    expect(File.exist? File.join(mock_path, 'nacis_mock.rb')).to eq false
  end
end

