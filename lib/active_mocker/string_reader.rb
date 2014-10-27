module ActiveMocker
  # @api private
  class StringReader
    def initialize(file)
      @read = file
    end

    def read(path)
      if @read.is_a?(Hash)
        @read[path.sub('/','').sub('.rb','')]
      else
        @read
      end
    end
  end

end

