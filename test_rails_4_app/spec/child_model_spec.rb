# frozen_string_literal: true
require "rails_helper"
require_mock "user_mock"
require_mock "child_model_mock"

describe ChildModel do
  it "column_names" do
    expect(ChildModelMock.column_names).to eq ChildModel.column_names
  end

  it "table_name" do
    expect(ChildModelMock.table_name).to eq ChildModel.table_name
  end

  it "associations" do
    expect(ChildModelMock.associations).to eq UserMock.associations.merge(accounts: nil)
  end

  it "has parent class of UserMock" do
    expect(ChildModelMock.superclass.name).to eq "UserMock"
  end

  it "has its methods" do
    expect(ChildModelMock.public_instance_methods.sort - Object.public_instance_methods).to eq ([:accounts, :accounts=, :child_method] + ChildModelMock.public_instance_methods.sort - Object.public_instance_methods).uniq.sort
  end

  it "has a parent method" do
    expect(ChildModelMock.instance_methods).to include(:id, :id=, :name, :name=, :email, :email=, :credits, :credits=, :created_at, :created_at=, :updated_at, :updated_at=, :password_digest, :password_digest=, :remember_token, :remember_token=, :admin, :admin=, :account, :account=, :build_account, :create_account, :create_account!, :microposts, :microposts=, :relationships, :relationships=, :followed_users, :followed_users=, :reverse_relationships, :reverse_relationships=, :followers, :followers=, :child_method, :feed, :following?, :follow!, :unfollow!)
  end

  it "scoped methods" do
    expect(ChildModelMock::Scopes.instance_methods).to include(*UserMock::Scopes.instance_methods, *:by_credits)
  end

  it "stubbed parent methods are stubbed on child" do
    allow_any_instance_of(UserMock).to receive(:feed) { "Feed!" }
    expect(ChildModelMock.new.feed).to eq "Feed!"
  end
end
