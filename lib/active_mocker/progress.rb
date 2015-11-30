module ActiveMocker
  class Progress
    def initialize(count)
      @progress = ProgressBar.create(title:  'Generating Mocks',
                                     total:  count,
                                     format: '%t |%b>>%i| %p%%')
    end

    def increment
      @progress.increment
    end
  end
end