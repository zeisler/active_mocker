require "spec_helper"
require "active_mocker/generate"
require "active_mocker/config"

RSpec.describe ActiveMocker::Generate do

  describe ".new" do

    before do
      ActiveMocker::Config.set do |config|
        config.model_dir = File.join(File.expand_path('../', __FILE__))
        config.mock_dir  = "mock_dir"
      end
    end

    context "model_dir" do
      it "ActiveMocker::Config.model_dir is valid and will not raise" do
        described_class.new
      end

      it "when ActiveMocker::Config.model_dir is nil" do
        expect(ActiveMocker::Config).to receive(:model_dir).and_return(nil)
        expect { described_class.new }.to raise_error(ArgumentError, "model_dir is missing a valued value!")
      end

      it "when ActiveMocker::Config.model_dir is empty string" do
        expect(ActiveMocker::Config).to receive(:model_dir).at_least(:once).and_return("")
        expect { described_class.new }.to raise_error(ArgumentError, "model_dir is missing a valued value!")
      end

      it "when ActiveMocker::Config.model_dir cannot be found" do
        expect(ActiveMocker::Config).to receive(:model_dir).at_least(:once).and_return("path")
        expect { described_class.new }.to raise_error(ArgumentError, "model_dir is missing a valued value!")
      end
    end

    context "mock_dir" do
      it "when ActiveMocker::Config.mock_dir is nil" do
        expect(ActiveMocker::Config).to receive(:mock_dir).and_return(nil)
        expect { described_class.new }.to raise_error(ArgumentError, "mock_dir is missing a valued value!")
      end

      it "when ActiveMocker::Config.mock_dir is empty string" do
        expect(ActiveMocker::Config).to receive(:mock_dir).at_least(:once).and_return("")
        expect { described_class.new }.to raise_error(ArgumentError, "mock_dir is missing a valued value!")
      end


      context "when ActiveMocker::Config.mock_dir cannot be found it will be created" do
        let(:not_found_dir) { File.join(File.expand_path('../test_mock_dir', __FILE__)) }

        it do
          expect(ActiveMocker::Config).to receive(:mock_dir).at_least(:once).and_return(not_found_dir)
          expect(Dir.exists?(not_found_dir)).to eq false
          described_class.new
          expect(Dir.exists?(not_found_dir)).to eq true
        end

        after do
          FileUtils.rmdir not_found_dir
        end
      end
    end
  end
end