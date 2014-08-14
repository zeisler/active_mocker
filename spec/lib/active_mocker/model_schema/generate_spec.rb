require 'rspec'
$:.unshift File.expand_path('../../../../../lib', __FILE__)
require 'active_mocker'
require 'json'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/deep_dup.rb'
require 'active_mocker/model_schema'
require 'active_mocker/model_schema'
require 'active_mocker/model_schema/generate'
require_relative '../../../unit_logger'

describe ActiveMocker::ModelSchema::Generate do

  let(:app_root) { File.expand_path('../../../../../', __FILE__) }
  let(:schema_file){ File.join(app_root, 'test_rails_4_app/db/schema.rb') }
  # let(:schema_file){ '/Users/zeisler/dev/fbi/db/schema.rb' }
  let(:models_dir){ File.join(app_root, 'test_rails_4_app/app/models') }
  # let(:models_dir){'/Users/zeisler/dev/fbi/app/models' }
  let(:run){described_class.new(schema_file: schema_file, models_dir: models_dir, logger: UnitLogger.unit).run.sort_by{|m| m.class_name}
  }

  it 'test' do
    result = described_class.new(schema_file: schema_file, models_dir: models_dir, logger: UnitLogger.unit).run
    expect(result.count).to eq 6
  end

  it 'relationships' do
    expect(run[-1].relationships.map{ |r| JSON.parse(r.to_json)})
      .to eq [{"name" => "account", "class_name" => "Account", "type" => "has_one", "foreign_key" => "account_id"}, {"name" => "microposts", "class_name" => "Micropost", "type" => "has_many", "foreign_key" => "user_id"}, {"name" => "relationships", "class_name" => "Relationship", "type" => "has_many", "foreign_key" => "follower_id"}, {"name" => "followed_users", "class_name" => "FollowedUser", "type" => "has_many", "foreign_key" => "user_id", "through" => "relationships"}, {"name" => "reverse_relationships", "class_name" => "Relationship", "type" => "has_many", "foreign_key" => "followed_id"}, {"name" => "followers", "class_name" => "Follower", "type" => "has_many", "foreign_key" => "user_id", "through" => "reverse_relationships"}]
  end

  it 'methods' do
    expect(run[-1].methods.map { |r| JSON.parse(r.to_json) })
      .to eq([{"name" => "find_by_name","arguments" =>[["req", "name"]],       "type" => "scope"},
              {"name" => "by_name",     "arguments" => [["req", "name"]], "type" => "scope"},
              {"name" => "feed",       "arguments" => [],                      "type" => "instance"},
              {"name" => "following?", "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "follow!",    "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "unfollow!",  "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "new_remember_token", "arguments" => [],              "type" => "class"},
              {"name" => "digest",     "arguments" => [["req", "token"]],      "type" => "class"}])
  end

  it 'arguments' do
    expect(run[-1].methods.last.arguments.passable).to eq('token')
  end

  it 'constants' do
    expect(run[3].constants).to eq({:MAGIC_ID_NUMBER => 90, :MAGIC_ID_STRING => "F-1"})
  end

  it 'modules' do
    expect(run[3].modules).to eq({:included => ['PostMethods'], :extended => ['PostMethods']})
  end

  it 'attributes' do
    expect(run[-1].attributes.map { |r| JSON.parse(r.to_json) })
    .to eq([{"name" => "id",              "type" => "integer", "primary_key" => true},
            {"name" => "name",            "type" => "string"},
            {"name" => "email",           "type" => "string", "default_value" => ""},
            {"name" => "credits",         "type" => "decimal", "precision" => 19, "scale" => 6},
            {"name" => "created_at",      "type" => "datetime"},
            {"name" => "updated_at",      "type" => "datetime"},
            {"name" => "password_digest", "type" => "string"},
            {"name" => "remember_token",  "type" => "boolean", "default_value" => true},
            {"name" => "admin",           "type" => "boolean", "default_value" => false}])
  end

  describe '#primary_key' do

    context 'when primary model has a primary key' do

      let(:given_model){OpenStruct.new(primary_key: 'user_id')}
      let(:given_attributes){ [OpenStruct.new(name: 'user_id'), OpenStruct.new(name: 'name')] }

      it 'will return attributes with that name' do
        expect(described_class.new.primary_key(given_attributes, given_model)).to eq(given_attributes.first)
      end

    end

    context 'when attributes has a primary key' do

      let(:given_model) { OpenStruct.new(primary_key: false) }
      let(:given_attributes) { [OpenStruct.new(name: 'user_id', primary_key: true), OpenStruct.new(name: 'name')] }

      it 'will return attributes with that name' do
        expect(described_class.new.primary_key(given_attributes, given_model)).to eq(given_attributes.first)
      end

    end

    context 'when attributes or model has no primary key' do

      let(:given_model) { OpenStruct.new(primary_key: false) }
      let(:given_attributes) { [OpenStruct.new(name: 'id'), OpenStruct.new(name: 'name')] }

      it 'will default to attribute with id' do
        expect(described_class.new.primary_key(given_attributes, given_model)).to eq(given_attributes.first)
      end

    end

    context 'when attributes or model has no primary key and there is no id attribute' do

      let(:given_model) { OpenStruct.new(primary_key: false) }
      let(:given_attributes) { [OpenStruct.new(name: 'something'), OpenStruct.new(name: 'name')] }

      it 'will return nil' do
        expect(described_class.new.primary_key(given_attributes, given_model)).to eq(nil)
      end

    end

  end

end