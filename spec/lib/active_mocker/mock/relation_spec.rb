require 'spec_helper'
require 'active_mocker/mock'
require 'ostruct'
require_relative 'has_many_shared_example'
require_relative 'queriable_shared_example'

describe ActiveMocker::Relation do
  it_behaves_like 'Queriable', -> (*args) { described_class.new(args.flatten) }
end
