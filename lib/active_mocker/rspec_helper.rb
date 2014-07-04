RSpec.configure do |config|

  def stub_class(klass)
    if defined?(Rails) && !active_mocker?
      return klass
    end
    ActiveMocker::LoadedMocks.class_name_to_mock.select { |class_name, mock| klass.name == class_name }.values.first
  end

  def active_mocker?
    bool = false
    begin
      bool = !!RSpec.current_example.metadata[:active_mocker]
      return true if bool
    rescue
      bool = false
    end

    begin
      bool = !!self.class.metadata[:active_mocker]
      return true if bool
    rescue
      bool = false
    end
    bool
  end

  # config.before(:each) do
  #   if RSpec.current_example.metadata[:active_mocker]
  #     ActiveMocker::LoadedMocks.class_name_to_mock.each { |class_name, mock| stub_const(class_name, mock) }
  #   end
  # end

  config.after(:all) do
    ActiveMocker::LoadedMocks.clear_all
  end

end