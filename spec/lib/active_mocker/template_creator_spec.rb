# frozen_string_literal: true
require "spec_helper"
require "spec/support/strip_heredoc"
require "active_mocker/template_creator"
require "active_record_schema_scrapper/attribute"
require "active_record_schema_scrapper/attributes"
require "tempfile"

describe ActiveMocker::TemplateCreator do
  using StripHeredoc

  describe "render" do
    it "return a file" do
      expect(described_class.new(erb_template: double("file", read: "", path: ""), binding: {}.send(:binding)).render.class).to eq(Tempfile)
    end

    it "takes an output file to write to" do
      file_out = Tempfile.new("fileout")
      described_class.new(erb_template: double("file", read: "hello", path: ""),
                          binding:      {}.send(:binding),
                          file_out:     file_out).render.class
      file_out.rewind
      expect(file_out.read).to eq("hello")
    end

    it "given template it will fulfill it based on template model" do
      class TestModel
        def model_name
          :ModelName
        end

        def get_binding
          binding
        end
      end
      template = Tempfile.new("Template")
      template.write <<-ERB
      class <%= model_name %>

      end
      ERB
      template.rewind
      result = described_class.new(erb_template:        template,
                                   binding: TestModel.new.get_binding).render
      result.rewind
      expect(result.read).to eq(<<-RUBY)
      class ModelName
      end
      RUBY
    end
  end
end
