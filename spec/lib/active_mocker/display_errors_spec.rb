require "spec_helper"
require "active_mocker/display_errors"
require "active_mocker/error_object"
require "active_mocker/config"
require "ostruct"
require "colorize"

RSpec.describe ActiveMocker::DisplayErrors do

  class StringOutPut
    def puts(str)
      to_a << str
    end

    def to_a
      @to_a ||= []
    end
  end

  let(:string_io) { StringOutPut.new }

  subject { described_class.new(1, out: string_io) }

  describe "#display_errors" do
    context "when error_verbosity is three" do
      context "when there are errors" do
        it "lists out full backtrace" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 3 }

          subject.add(ActiveMocker::ErrorObject.new(level:          :error,
                                                    message:        "none",
                                                    class_name:     "Buggy",
                                                    type:           :overload,
                                                    original_error: OpenStruct.new(backtrace: ["this this the backtrace"],
                                                                                   message:   "Original Error message")))
          subject.display_errors
          expect(string_io.to_a).to eq ["Buggy has the following errors:",
                                        "\e[0;31;49mnone\e[0m", :error,
                                        "\e[0;31;49mOriginal Error message\e[0m",
                                        ["this this the backtrace"], "\e[0;31;49mOpenStruct\e[0m",
                                        "Error Summary", "errors: 1, warn: 0, info: 0", "1 mock(s) out of 1 failed.",
                                        "To see more/less detail set error_verbosity = 0, 1, 2, 3"]
        end
      end

      context "when there are no errors" do
        it "displays all good message" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 3 }
          subject.display_errors
          expect(string_io.to_a).to eq ["1 mock(s) out of 1 failed."]
        end
      end
    end

    context "when error_verbosity is two" do
      context "when there are errors" do
        it "lists out full backtrace" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 2 }

          subject.add(ActiveMocker::ErrorObject.new(level:          :error,
                                                    message:        "This is the Message",
                                                    class_name:     "Buggy",
                                                    type:           :overload,
                                                    original_error: OpenStruct.new(backtrace: ["this this the backtrace"],
                                                                                   message:   "Original Error message")))
          subject.display_errors
          expect(string_io.to_a).to eq ["\e[0;31;49mThis is the Message\e[0m",
                                        "Error Summary",
                                        "errors: 1, warn: 0, info: 0", "1 mock(s) out of 1 failed.",
                                        "To see more/less detail set error_verbosity = 0, 1, 2, 3"]
        end
      end
      context "when there are no errors" do
        it "displays all good message" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 2 }
          subject.display_errors
          expect(string_io.to_a).to eq ["1 mock(s) out of 1 failed."]
        end
      end
    end
  end

  describe "#failure_count_message" do
    context "when error_verbosity is zero" do
      it "lists out nothing" do
        allow(ActiveMocker::Config).to receive(:error_verbosity) { 0 }
        subject.failure_count_message
        expect(string_io.to_a).to eq []
      end
    end

    context "when error_verbosity is one" do
      context "when a mock has failed" do
        it "lists out x out y failed message" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 1 }
          subject.failure_count_message
          expect(string_io.to_a.first).to eq "1 mock(s) out of 1 failed."
        end
      end

      context "when a mock has errored" do
        it "lists out x out y failed message" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 1 }
          subject.add(ActiveMocker::ErrorObject.new(level: :error, message: "none", class_name: "Buggy", type: :overload))
          subject.success_count += 1
          subject.failure_count_message
          expect(string_io.to_a).to eq ["0 mock(s) out of 1 failed."]
        end
      end

      context "when no failures or errors" do
        it "lists out nothing" do
          allow(ActiveMocker::Config).to receive(:error_verbosity) { 1 }
          subject.success_count += 1
          subject.failure_count_message
          expect(string_io.to_a).to eq []
        end
      end
    end
  end

  describe "#error_summary" do

    context "with failed models" do
      it "outputs a list of failed models" do
        subject.success_count += 1
        subject.failed_models << "hello"
        subject.failed_models << "goodbye"
        subject.error_summary
        expect(string_io.to_a.last).to eq "Failed models: hello, goodbye"
      end
    end

    context "without failed models" do

      it "outputs only warnings" do
        subject.success_count += 1
        subject.error_summary
        expect(string_io.to_a).to eq ["errors: 0, warn: 0, info: 0"]
      end
    end

    context "with an error count" do

      it "outputs only warnings" do
        subject.add(ActiveMocker::ErrorObject.new(level: :error, message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(level: :error, message: "none", class_name: "Buggy", type: :overload))
        subject.error_summary
        expect(string_io.to_a.first).to eq "errors: 2, warn: 0, info: 0"
      end
    end

    context "with an warn count" do

      it "outputs only warnings" do
        subject.add(ActiveMocker::ErrorObject.new(message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(message: "none", class_name: "Buggy", type: :overload))
        subject.error_summary
        expect(string_io.to_a.first).to eq "errors: 0, warn: 3, info: 0"
      end
    end

    context "with an info count" do

      it "outputs only warnings" do
        subject.add(ActiveMocker::ErrorObject.new(level: :info, message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(level: :info, message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(level: :info, message: "none", class_name: "Buggy", type: :overload))
        subject.add(ActiveMocker::ErrorObject.new(level: :info, message: "none", class_name: "Buggy", type: :overload))
        subject.error_summary
        expect(string_io.to_a.first).to eq "errors: 0, warn: 0, info: 4"
      end
    end
  end
end
