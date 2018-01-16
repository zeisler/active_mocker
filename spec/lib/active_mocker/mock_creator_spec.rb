# frozen_string_literal: true
require "spec_helper"
require "lib/post_methods"
require "active_support/core_ext/string"
require "spec/support/strip_heredoc"
require "active_mocker/error_object"
require "active_mocker/hash_new_style"
require "active_mocker/parent_class"
require "active_mocker/template_creator"
require "active_mocker/mock_creator"
require "active_record_schema_scrapper"
require "dissociated_introspection"
require "reverse_parameters"
require "tempfile"
require "lib/active_mocker/mock_creator/associations"
require "lib/active_mocker/mock_creator/attributes"
require "lib/active_mocker/mock_creator/class_methods"
require "lib/active_mocker/mock_creator/defined_methods"
require "lib/active_mocker/mock_creator/modules_constants"
require "lib/active_mocker/mock_creator/recreate_class_method_calls"
require "lib/active_mocker/mock_creator/mock_build_version"
require "lib/active_mocker/mock_creator/scopes"
require "lib/active_mocker/attribute"

describe ActiveMocker::MockCreator do
  before do
    stub_const("ActiveRecord::Base", active_record_stub_class)
    stub_const("ActiveRecord::VERSION::MAJOR", 5)
    stub_const("ActiveRecord::VERSION::MINOR", 0)
    stub_const("ActiveRecord::VERSION::STRING", "5.0.0")
  end

  let(:active_record_stub_class) { Class.new }

  def format_code(code)
    DissociatedIntrospection::RubyCode.build_from_source(code).source_from_ast
  end

  class ModelStandInForARVersion
    module PostMethods
    end

    include PostMethods
  end

  let(:active_record_model) { ModelStandInForARVersion }

  describe "#create" do
    subject do
      lambda do |partials|
        s = described_class.new(file:                 file_in,
                                file_out:             file_out,
                                schema_scrapper:      stub_schema_scrapper,
                                enabled_partials:     partials,
                                klasses_to_be_mocked: [],
                                mock_append_name:     "Mock",
                                active_record_model:  active_record_model).create
        expect(s.errors).to eq []
        format_code(File.open(file_out.path).read)
      end
    end

    let(:file_out) do
      Tempfile.new("fileOut")
    end

    let(:file_in) do
      File.new(File.join(File.dirname(__FILE__), "../models/model.rb"))
    end

    let(:rails_model) do
      double("RailsModel")
    end

    let(:stub_schema_scrapper) do
      s = ActiveRecordSchemaScrapper.new(model: rails_model)
      allow(s).to receive(:attributes) { sample_attributes }
      allow(s).to receive(:associations) { sample_associations }
      allow(s).to receive(:table_name) { "example_table" }
      allow(s).to receive(:abstract_class?) { false }
      s
    end

    let(:sample_attributes) do
      a = ActiveRecordSchemaScrapper::Attributes.new(model: rails_model)
      allow(a).to receive(:to_a) {
        [
          ActiveRecordSchemaScrapper::Attribute.new(
            name:    "example_attribute",
            type:    :string,
            default: "something"
          ),
          ActiveRecordSchemaScrapper::Attribute.new(
            name:    "example_decimal",
            type:    :decimal,
            default: -1.0,
          )
        ]
      }
      a
    end

    let(:sample_associations) do
      a = ActiveRecordSchemaScrapper::Associations.new(model: rails_model)
      allow(a).to receive(:to_a) {
        [
          ActiveRecordSchemaScrapper::Association.new(name: :user, class_name: :User, type: :belongs_to, through: nil, source: nil, foreign_key: :user_id, join_table: nil, dependent: nil),
          ActiveRecordSchemaScrapper::Association.new(name: :account, class_name: :Account, type: :has_one, through: nil, source: nil, foreign_key: :account_id, join_table: nil, dependent: nil),
          ActiveRecordSchemaScrapper::Association.new(name: :person, class_name: :Person, type: :has_many, through: nil, source: nil, foreign_key: :person_id, join_table: nil, dependent: nil),
          ActiveRecordSchemaScrapper::Association.new(name: :other, class_name: :Other, type: :has_and_belongs_to_many, through: nil, source: nil, foreign_key: :other_id, join_table: nil, dependent: nil),
        ]
      }
      a
    end

    describe "error cases" do
      let(:file_in) do
        f = Tempfile.new("name")
        f.write model_string
        f.close
        File.open(f.path)
      end
      subject do
        described_class.new(file:                 file_in,
                            file_out:             file_out,
                            schema_scrapper:      stub_schema_scrapper,
                            enabled_partials:     [],
                            klasses_to_be_mocked: [],
                            mock_append_name:     "Mock",
                            active_record_model:  active_record_model).create
      end
      describe "has no parent class" do
        let(:model_string) do
          <<-RUBY.strip_heredoc
        class ParentLessChild
        end
          RUBY
        end

        it do
          expect(subject.errors.first.message).to eq("ParentLessChild is missing a parent class.")
          expect(subject.completed?).to eq false
          expect(file_out.read).to eq ""
        end
      end

      describe "adding to valid parent classes" do
        subject do
          described_class.new(file:                 file_in,
                              file_out:             file_out,
                              schema_scrapper:      stub_schema_scrapper,
                              enabled_partials:     [],
                              klasses_to_be_mocked: [],
                              mock_append_name:     "Mock",
                              active_record_model:  active_record_model
          ).create
        end
        let(:model_string) do
          <<-RUBY.strip_heredoc
        class Child < ActiveRecord::Base
        end
          RUBY
        end

        it do
          expect(subject.errors.empty?).to eq true
          expect(subject.completed?).to eq true
        end
      end
    end

    it "run all partials" do
      expect(subject.call(nil).class).to eq String
    end

    context "when it mock is in modules" do
      let(:file_in) do
        File.new(File.join(File.dirname(__FILE__), "../models/model.rb"))
      end

      it "partial :attributes" do
        expect(subject.call([:attributes])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          def example_attribute
            read_attribute(:example_attribute)
          end

          def example_attribute=(val)
            write_attribute(:example_attribute, val)
          end

          def example_decimal
            read_attribute(:example_decimal)
          end

          def example_decimal=(val)
            write_attribute(:example_decimal, val)
          end

          def id
            read_attribute(:id)
          end

          def id=(val)
            write_attribute(:id, val)
          end

        end
        RUBY
      end
    end

    it "partial :mock_build_version" do
      expect(subject.call([:mock_build_version])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          mock_build_version("2", active_record: "#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}")
        end
      RUBY
    end

    context "rails 5.1" do
      before do
        stub_const("ActiveRecord::VERSION::MAJOR", 5)
        stub_const("ActiveRecord::VERSION::MINOR", 1)
      end

      it "partial :mock_build_version rails 5.1" do
        expect(subject.call([:mock_build_version])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          mock_build_version("2", active_record: "5.1")
        end
        RUBY
      end
    end

    it "partial :class_methods" do
      expect(subject.call([:class_methods])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          class << self
            private

            def attributes
              @attributes ||= HashWithIndifferentAccess.new({example_attribute: "something", example_decimal: BigDecimal("-1.0"), id: nil}).merge(super)
            end

            def types
              @types ||= ActiveMocker::HashProcess.new({ example_attribute: String, example_decimal: BigDecimal, id: Integer }, method(:build_type)).merge(super)
            end

            def associations
              @associations ||= {:user=>nil, :account=>nil, :person=>nil, :other=>nil}.merge(super)
            end

            def associations_by_class
              @associations_by_class ||= {"User"=>{:belongs_to=>[:user]}, "Account"=>{:has_one=>[:account]}, "Person"=>{:has_many=>[:person]}, "Other"=>{:has_and_belongs_to_many=>[:other]}}.merge(super)
            end

            def mocked_class
              "Model"
            end

            public

            def attribute_names
              @attribute_names ||= attributes.stringify_keys.keys
            end

            def primary_key
              "id"
            end

            def abstract_class?
              false
            end

            def table_name
              "example_table" || super
            end

          end
        end
      RUBY
    end

    it "partial :modules_constants" do
      expect(subject.call([:modules_constants])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          MY_CONSTANT_VALUE = 3
          MY_OBJECT = ActiveMocker::UNREPRESENTABLE_CONST_VALUE
          module FooBar
          end
          prepend FooBar
          prepend ModelStandInForARVersion::PostMethods
        end
      RUBY
    end

    it "partial :scopes" do
      results = subject.call([:scopes])
      expect(results).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          module Scopes
            include ActiveMocker::Base::Scopes

            def named(name, value=nil, options=nil)
              2 + 2
            end

            def other_named
              __am_raise_not_mocked_error(method: "other_named", caller: Kernel.caller, type: "::")
            end

          end

          extend Scopes

          class ScopeRelation < ActiveMocker::Association
            include ModelMock::Scopes
            include(ClassMethods)
          end

          def self.__new_relation__(collection)
            ModelMock::ScopeRelation.new(collection)
          end

          private_class_method :__new_relation__
        end
      RUBY
    end

    it "partial :defined_methods" do
      expect(subject.call([:defined_methods])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
          def foo(foobar, value)
          end
          def superman
            __method__
          end
          module ClassMethods
            def bang!
              :boom!
            end
            def duper(value, *args)
              __am_raise_not_mocked_error(method: __method__, caller: Kernel.caller, type: "::")
            end
            def foo
              :buz
            end
          end
          extend(ClassMethods)

        end
      RUBY
    end

    it "partial :associations" do
      expect(subject.call([:associations])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base
         
          def user
            read_association(:user) || write_association(:user, classes("User").try do |k|
              k.find_by(id: user_id)
            end)
          end

          def user=(val)
            write_association(:user, val)
            ActiveMocker::BelongsTo.new(val, child_self: self, foreign_key: :user_id).item
          end

          def build_user(attributes={}, &block)
            self.user = classes("User", true).new(attributes, &block)
          end

          def create_user(attributes={}, &block)
            self.user = classes("User", true).create(attributes, &block)
          end

          alias_method :create_user!, :create_user
          def account
            read_association(:account)
          end

          def account=(val)
            write_association(:account, val)
            ActiveMocker::HasOne.new(val, child_self: self, foreign_key: 'account_id').item
          end

          def build_account(attributes={}, &block)
            self.account = classes("Account", true).new(attributes, &block)
          end

          def create_account(attributes={}, &block)
            self.account = classes("Account", true).new(attributes, &block)
          end
          alias_method :create_account!, :create_account

          def person
            read_association(:person, -> { ActiveMocker::HasMany.new([],foreign_key: 'person_id', foreign_id: self.id, relation_class: classes('Person'), source: '') })
          end

          def person=(val)
            write_association(:person, ActiveMocker::HasMany.new(val, foreign_key: 'person_id', foreign_id: self.id, relation_class: classes('Person'), source: ''))
          end

          def other
            read_association(:other, lambda do
              ActiveMocker::HasAndBelongsToMany.new([], foreign_key: "other_id", foreign_id: self.id, relation_class: classes("Other"), source: "")
            end)
          end

          def other=(val)
            write_association(:other, ActiveMocker::HasAndBelongsToMany.new(val, foreign_key: "other_id", foreign_id: self.id, relation_class: classes("Other"), source: ""))
          end
        end
      RUBY
    end

    it "partial :recreate_class_method_calls" do
      expect(subject.call([:recreate_class_method_calls])).to eq format_code <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Base

          def self.attribute_aliases
            @attribute_aliases ||= { "full_name" => "name" }.merge(super)
          end

          alias_method(:full_name, :name)
          alias_method(:full_name=, :name=)

        end
      RUBY
    end
  end
end
