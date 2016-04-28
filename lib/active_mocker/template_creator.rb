# frozen_string_literal: true
require "forwardable"

module ActiveMocker
  class TemplateCreator
    def initialize(erb_template:, file_out: nil, binding:, post_process: -> (str) { str })
      @erb_template = erb_template
      @binding      = binding
      @file_out     = file_out || Tempfile.new("TemplateModel")
      @post_process = post_process
    end

    def render
      template = ERB.new(erb_template.read, nil, ">")
      file_out.write post_process.call(template.result(binding))
      file_out
    end

    private

    attr_reader :erb_template, :binding, :file_out, :post_process
  end
end
