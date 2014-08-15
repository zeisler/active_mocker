require 'spec_helper'
require 'active_mocker/mock/queries'
require 'active_mocker/mock/collection'
require 'active_mocker/mock/relation'
require 'active_mocker/mock/association'
require 'active_mocker/mock/has_many'
require 'ostruct'
require_relative 'has_many_shared_example'
require_relative 'queriable_shared_example'

describe ActiveMocker::Mock::Association do
  it_behaves_like 'Queriable', -> (*args) { described_class.new(args.flatten) }
end


