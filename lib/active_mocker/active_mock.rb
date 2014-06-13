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
require 'active_mock/queries'
require 'active_mock/collection'
require 'active_mock/association'
require 'active_mock/has_many'
require 'active_mocker/loaded_mocks'
require 'active_mock/base'
require 'virtus'