$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/relationships'
require 'active_mocker/active_record/unknown_class_method'
require 'active_mocker/active_record/unknown_module'

module ActiveMocker
  module ActiveRecord
    class Base
      extend Scope
      extend Relationships
      extend UnknownClassMethod
      extend UnknownModule
    end
  end
end
