require 'active_mocker/collection_association'
require 'active_mocker/mock_class_methods'
require 'active_mocker/mock_instance_methods'
require 'active_hash'
require 'active_hash/ar_api'

def class_exists?(class_name)
  klass = Module.const_get(class_name)
  return klass.is_a?(Class)
rescue NameError
  return false
end