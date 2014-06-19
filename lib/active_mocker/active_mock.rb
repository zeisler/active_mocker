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
require 'active_mock/has_and_belongs_to_many'
require 'active_mocker/loaded_mocks'
require 'active_mock/mock_abilities'
require 'active_mock/exceptions'
require 'active_mock/template_methods'
require 'active_mock/do_nothing_active_record_methods'
require 'active_mock/next_id'
require 'active_mock/creators'
require 'active_mock/records'
require 'active_mock/base'
require 'virtus'
require 'active_mock/object_inspect'
