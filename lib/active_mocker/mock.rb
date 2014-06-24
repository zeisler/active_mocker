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
require 'active_mocker/loaded_mocks'
require 'active_mocker/mock/collection'
require 'active_mocker/mock/queries'
require 'active_mocker/mock/association'
require 'active_mocker/mock/has_many'
require 'active_mocker/mock/has_and_belongs_to_many'
require 'active_mocker/mock/mock_abilities'
require 'active_mocker/mock/exceptions'
require 'active_mocker/mock/template_methods'
require 'active_mocker/mock/do_nothing_active_record_methods'
require 'active_mocker/mock/next_id'
require 'active_mocker/mock/creators'
require 'active_mocker/mock/records'
require 'active_mocker/mock/object_inspect'
require 'active_mocker/mock/base'
require 'virtus'
