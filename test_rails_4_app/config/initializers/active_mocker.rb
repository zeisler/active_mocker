ActiveMocker.configure do |config|
  config.model_base_classes << 'OmniAuth::Identity::Models::ActiveRecord'
end