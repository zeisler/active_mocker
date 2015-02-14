require 'rails_helper'
require_relative 'active_record_compatible_api'

describe User do

  it_behaves_like 'ActiveRecord', Micropost, Account

end