require "active_mocker/version"
$:.unshift File.expand_path('../../', __FILE__)

require 'active_mocker/railtie' if defined?(Rails)
require 'active_mocker/ar_methods' if defined?(Rails)
require 'active_mocker/public_methods'
require 'active_mocker/config'
require 'active_mocker/generate'
require 'singleton'
require 'logger'
require 'active_mocker/logger'
require 'active_support/all'
require 'active_mocker/table'
require 'active_mocker/field'
require 'file_reader'
require 'active_mocker/reparameterize'
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/schema_reader'
require 'active_mocker/active_record/schema'
require 'active_mocker/active_record'
require 'active_mocker/model_reader'
require 'active_mocker/reparameterize'
require 'active_mocker/db_to_ruby_type'
require 'active_mocker/model_schema'
require 'active_mocker/model_schema/generate'
require 'virtus'