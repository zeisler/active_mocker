require 'spec_helper'
require_relative 'mocks/user_mock.rb'

describe UserMock do

  describe 'new_relation' do

    it 'is a private method only because it not be used in your code only your tests because ActiveRecord does not support it' do
      collection = [UserMock.new(name: 'David')]
      expect(UserMock.send(:new_relation, collection).where(name: 'David')).to eq collection
      expect(UserMock.where(name: 'David')).not_to eq collection
    end

  end

end