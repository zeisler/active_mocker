require 'forwardable'

module ActiveMocker
  class TemplateCreator

    def initialize(erb_template:, file_out: nil, binding:)
      @erb_template = erb_template
      @binding      = binding
      @file_out     = file_out || Tempfile.new('TemplateModel')
    end

    def render
      template = ERB.new(erb_template.read, nil, '>')
      file_out.write template.result(binding).gsub(/\n{2,5}/, "\n\n")
      file_out
    end

    private

    attr_reader :erb_template, :binding, :file_out
  end
end