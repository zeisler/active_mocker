require 'rspec'
$:.unshift File.expand_path('../../../../../lib/active_mocker/mock', __FILE__)
require 'collection'
require 'queries'
require 'association'
require 'has_many'
require 'has_and_belongs_to_many'
require_relative 'has_many_shared_example'

describe ActiveMocker::Mock::HasAndBelongsToMany do
  it_behaves_like 'HasMany'
end