require 'spec_helper'
require 'logger'
require 'active_mocker/config'

describe ActiveMocker::Config do

  after do
    described_class.reset_all
    described_class.load_defaults
  end

  before do
    described_class.reset_all
    described_class.load_defaults
  end

  it do

  end

end