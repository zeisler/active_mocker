$:.unshift File.expand_path('../../', __FILE__)
require 'active_mocker/active_record/scope'
require 'active_mocker/active_record/relationships'

module ActiveMocker
  module ActiveRecord
    class Base
      extend Scope
      extend Relationships
    end
  end
end
