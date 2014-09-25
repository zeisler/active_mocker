require 'spec_helper'
require_relative 'active_record_shared_example'

describe User do

  it_behaves_like 'ActiveRecord', Micropost, Account

end