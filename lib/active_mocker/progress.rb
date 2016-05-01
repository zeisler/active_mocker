# frozen_string_literal: true
module ActiveMocker
  class Progress
    def self.create(count)
      require "ruby-progressbar"
      new(count)
    rescue LoadError
      NullProgress.new
    end

    def initialize(count)
      @count = count
    end

    delegate :increment, to: :progress

    def progress
      @progress ||= ProgressBar.create(title:  "Generating Mocks",
                                       total:  @count,
                                       format: "%t |%b>>%i| %p%%")
    end
  end
end
