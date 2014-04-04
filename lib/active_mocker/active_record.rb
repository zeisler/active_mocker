$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/relationships'
require 'active_mocker/active_record/unknown_class_method'
require 'active_mocker/active_record/unknown_module'
require 'active_mocker/active_record/const_missing'

module ActiveMocker
  module ActiveRecord
    class Base
      extend Scope
      extend Relationships
      extend UnknownClassMethod
      extend UnknownModule
      extend ConstMissing

      def self.const_missing(name)
        # Logger_.debug "ActiveMocker :: Can't can't find Constant #{name} from class #{}."
      end
    end
  end
end
