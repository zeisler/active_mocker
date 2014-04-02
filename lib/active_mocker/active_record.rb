$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/relationships'
require 'active_mocker/active_record/unknown_class_method'

module ActiveMocker
  module ActiveRecord
    class Base
      extend Scope
      extend Relationships
      extend UnknownClassMethod
    end
  end
end
