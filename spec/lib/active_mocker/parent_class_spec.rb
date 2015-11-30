require "spec_helper"
require 'active_mocker/parent_class'
require 'dissociated_introspection'

RSpec.describe ActiveMocker::ParentClass do

  before do
    stub_const("::ActiveRecord::Base", active_record_stub_class)
    allow_any_instance_of(String).to receive(:constantize) { child_class }
  end

  let(:active_record_stub_class) { Class.new }
  let(:child_class) { Class.new(active_record_stub_class) }
  let(:klasses_to_be_mocked) { [] }
  describe "#call" do
    subject { described_class.new(parsed_source:        parsed_source,
                                  klasses_to_be_mocked: klasses_to_be_mocked,
                                  mock_append_name:     "MockTest").call }
    let(:parsed_source) { instance_double(DissociatedIntrospection::RubyClass,
                                          has_parent_class?: false,
                                          class_name:        "ParentLessChild") }
    context "When no parent class" do

      describe "#parent_mock_name" do
        it "returns the default parent class" do
          expect(subject.parent_mock_name).to eq "ActiveMocker::Mock::Base"
        end
      end

      describe "#error" do
        it "returns object with #message" do
          expect(subject.error.message).to eq "ParentLessChild is missing a parent class."
        end
      end
    end

    context "When it has a parent class that inherits from ActiveRecord" do
      let(:child_class) { Class.new(active_record_stub_class) }
      let(:parsed_source) { instance_double(DissociatedIntrospection::RubyClass,
                                            has_parent_class?: true,
                                            class_name:        "ChildOfAR",
                                            parent_class_name: "MyClassInheritsFromAR") }

      describe "#parent_mock_name" do
        it "returns the default parent class" do
          expect(subject.parent_mock_name).to eq "ActiveMocker::Mock::Base"
        end
      end

      describe "#error" do
        it "returns nil" do
          expect(subject.error).to eq nil
        end
      end
    end

    context "When it has a parent class that does not inherits from ActiveRecord" do
      let(:parsed_source) { instance_double(DissociatedIntrospection::RubyClass,
                                            has_parent_class?: true,
                                            class_name:        "ChildOfNonAr",
                                            parent_class_name: "NoneArInheritor") }
      let(:child_class) { Class.new }

      describe "#parent_mock_name" do
        it "returns the default parent class" do
          expect(subject.parent_mock_name).to eq "ActiveMocker::Mock::Base"
        end
      end

      describe "#error" do
        it "returns the default parent class" do
          expect(subject.error.message).to eq "ChildOfNonAr does not inherit from ActiveRecord::Base"
        end
      end
    end

    context "When it has a parent class that does inherits from ActiveRecord and is in klasses_to_be_mocked " do
      let(:child_class) { Class.new(active_record_stub_class) }
      let(:parsed_source) { instance_double(DissociatedIntrospection::RubyClass,
                                            has_parent_class?: true,
                                            class_name:        "ChildOfSTI",
                                            parent_class_name: "STIModel") }
      let(:klasses_to_be_mocked) { ["STIModel"] }

      describe "#parent_mock_name" do
        it "returns the default parent class" do
          expect(subject.parent_mock_name).to eq "STIModelMockTest"
        end
      end

      describe "#error" do
        it "returns nil" do
          expect(subject.error).to eq nil
        end
      end
    end
  end
end