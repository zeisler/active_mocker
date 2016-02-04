require 'rails_helper'

describe "rake active_mocker:build" do
  it "builds the mocks from the model dir" do
    expect(File.exist? mock_path).to eq true
    expect(File.exist? File.join(mock_path, 'user_mock.rb')).to eq true
    expect(File.exist? File.join(mock_path, 'micropost_mock.rb')).to eq true
    expect(File.exist? File.join(mock_path, 'relationship_mock.rb')).to eq true
    result = File.exist?(File.join(mock_path, 'api/customer_mock.rb'))
    puts ""
    puts mock_path
    system "ls #{mock_path}"
    puts File.join(mock_path, 'api')
    system "ls #{File.join(mock_path, 'api')}"
    expect(result).to eq true
    expect(File.exist? File.join(mock_path, 'nacis_mock.rb')).to eq false
  end
end

