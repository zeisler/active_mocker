require 'active_support'

begin
  require 'active_support/core_ext'
rescue
end

begin
  require 'active_model'
  require 'active_model/naming'
rescue LoadError
end
require 'active_mocker/logger'
require 'active_mocker/queries'
require 'active_mocker/collection'
require 'active_mocker/association'
require 'active_mocker/has_many'
require 'active_mocker/loaded_mocks'
require 'active_mocker/base'
require 'active_mocker/class_exists'
require 'virtus'