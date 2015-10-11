require 'spec_helper'
require 'spec/support/strip_heredoc'
require 'active_mocker/active_record'
require 'active_mocker/v2/template_creator'
require 'active_mocker/v2/mock_creator'
require 'active_record_schema_scrapper'
require 'dissociated_introspection'
require 'tempfile'

describe ActiveMocker::V2::MockCreator do

  describe "#create" do

    let(:file_out) {
      Tempfile.new('fileOut')
    }

    let(:file_in) {
      File.new(File.join(File.dirname(__FILE__), "../../model.rb"))
    }

    let(:rails_model) {
      double("RailsModel")
    }

    let(:stub_schema_scrapper) {
      s = ActiveRecordSchemaScrapper.new(model: rails_model)
      allow(s).to receive(:attributes) { sample_attributes }
      allow(s).to receive(:associations) { sample_associations }
      allow(s).to receive(:table_name) { "example_table" }
      allow(s).to receive(:abstract_class?) { false }
      s
    }

    let(:sample_attributes) {
      a = ActiveRecordSchemaScrapper::Attributes.new(model: rails_model)
      allow(a).to receive(:to_a) { [ActiveRecordSchemaScrapper::Attribute.new(name: "example_attribute", type: :string)] }
      a
    }

    let(:sample_associations) {
      a = ActiveRecordSchemaScrapper::Associations.new(model: rails_model)
      allow(a).to receive(:to_a) { [ActiveRecordSchemaScrapper::Association.new(name: :account, class_name: :Account, type: :has_one, through: nil, source: nil, foreign_key: :user_id, join_table: nil, dependent: nil)] }
      a
    }

    subject { ->(partials) {
      described_class.new(file:             file_in,
                          file_out:         file_out,
                          schema_scrapper:  stub_schema_scrapper,
                          enabled_partials: partials).create
      File.open(file_out.path).read
    } }

    it 'partial :attributes' do
      expect(subject.call([:attributes])).to eq <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Mock::Base
          created_with('#{ActiveMocker::VERSION}')

        # _attributes.erb
          def example_attribute
            read_attribute(:example_attribute)
          end

          def example_attribute=(val)
            write_attribute(:example_attribute, val)
          end

        end
      RUBY
    end

    xit 'partial :modules_constants' do
      expect(subject.call([:modules_constants])).to eq <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Mock::Base
          created_with('#{ActiveMocker::VERSION}')
        # _modules_constants.erb
          MY_CONSTANT_VALUE = 3


        end
      RUBY
    end

    it 'partial :class_methods' do
      expect(subject.call([:class_methods])).to eq <<-RUBY.strip_heredoc
        require 'active_mocker/mock'

        class ModelMock < ActiveMocker::Mock::Base
          created_with('#{ActiveMocker::VERSION}')

        #_class_methods.erb
          class << self
            def attributes
              @attributes ||= HashWithIndifferentAccess.new({"example_attribute"=>nil}).merge(super)
            end

            def types
              @types ||= ActiveMocker::Mock::HashProcess.new({ example_attribute: String }, method(:build_type)).merge(super)
            end

            def associations
              @associations ||= {:account=>nil}.merge(super)
            end

            def associations_by_class
              @associations_by_class ||= {:Account=>{:has_one=>[:account]}}.merge(super)
            end

            def mocked_class
              "Model"
            end

            private :mocked_class

            def attribute_names
              @attribute_names ||= ["example_attribute"] | super
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
  end
end