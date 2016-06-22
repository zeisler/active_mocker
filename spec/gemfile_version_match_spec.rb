# frozen_string_literal: true
RSpec.describe "Gemfile Version Match" do
  it "rails_4.1.gemfile.lock" do
    file = File.join(File.expand_path("../../", __FILE__), "test_rails_4_app/gemfiles/rails_4.1.gemfile.lock")
    expect(!File.readlines(file).grep(/active_mocker \(#{Regexp.quote(ActiveMocker::VERSION)}\)/).empty?).to eq true
  end

  it "rails_4.2.gemfile.lock" do
    file = File.join(File.expand_path("../../", __FILE__), "test_rails_4_app/gemfiles/rails_4.2.gemfile.lock")
    expect(!File.readlines(file).grep(/active_mocker \(#{Regexp.quote(ActiveMocker::VERSION)}\)/).empty?).to eq true
  end

  it "rails_5.0.gemfile.lock" do
    file = File.join(File.expand_path("../../", __FILE__), "test_rails_4_app/gemfiles/rails_5.0.gemfile.lock")
    expect(!File.readlines(file).grep(/active_mocker \(#{Regexp.quote(ActiveMocker::VERSION)}\)/).empty?).to eq true
  end
end
