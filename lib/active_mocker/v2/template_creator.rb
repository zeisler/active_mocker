require 'forwardable'

module ActiveMocker
  module V2
    class TemplateCreator

      def initialize(erb_template:, file_out: nil ,binding:)
        @erb_template = erb_template
        @binding      = binding
        @file_out     = file_out || Tempfile.new('TemplateModel')
      end

      # Suppressing Newlines
      #
      # The third parameter of new specifies optional modifiers, most of which alter when newline characters will be automatically added to the output.For example, ERB will not print newlines after tags if you give > as the third parameter:
      #
      #
      #  renderer = ERB.new(template, 3, '>')

      def render
        template          = ERB.new(erb_template.read, nil, '-')
        # template.location erb_template.path, 0
        file_out.write template.result(binding).gsub(/\n{2,5}/, "\n\n")
        file_out
      end

      private

      attr_reader :erb_template, :binding, :file_out
    end
  end
end