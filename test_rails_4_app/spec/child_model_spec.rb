require 'spec_helper'
require_relative 'mocks/child_model_mock'

describe 'ChildModel' do

  it 'column_names' do
    expect(ChildModelMock.column_names).to eq ChildModel.column_names
  end

end