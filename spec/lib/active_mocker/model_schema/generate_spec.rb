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
  # let(:schema_file){ File.join(app_root, 'sample_app_rails_4/db/schema.rb') }
  let(:schema_file){ '/Users/zeisler/dev/fbi/db/schema.rb' }
  # let(:models_dir){ File.join(app_root, 'sample_app_rails_4/app/models') }
  let(:models_dir){'/Users/zeisler/dev/fbi/app/models' }
  let(:run){described_class.new(schema_file: schema_file, models_dir: models_dir, logger: UnitLogger.unit).run
  }
  it 'test' do
    result = described_class.new(schema_file: schema_file, models_dir: models_dir, logger: UnitLogger.unit).run

  end

  it 'relationships' do
    expect(run[-1].relationships.map{ |r| JSON.parse(r.to_json)})
      .to eq [{"name" => "microposts", "class_name" => "Micropost", "type" => "has_many", "foreign_key" => "user_id"},
              {"name" => "relationships", "class_name" => "Relationship", "type" => "has_many", "foreign_key" => "follower_id"},
              {"name" => "followed_users", "class_name" => "FollowedUser", "type" => "has_many", "foreign_key" => "user_id", "through" => "relationships"},
              {"name" => "reverse_relationships", "class_name" => "Relationship", "type" => "has_many", "foreign_key" => "followed_id"},
              {"name" => "followers", "class_name" => "Follower", "type" => "has_many", "foreign_key" => "user_id", "through" => "reverse_relationships"}]
  end

  it 'methods' do
    expect(run[-1].methods.map { |r| JSON.parse(r.to_json) })
      .to eq([{"name" => "feed",       "arguments" => nil,                     "type" => "instance"},
              {"name" => "following?", "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "follow!",    "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "unfollow!",  "arguments" => [["req", "other_user"]], "type" => "instance"},
              {"name" => "new_remember_token", "arguments" => nil,             "type" => "class"},
              {"name" => "digest",     "arguments" => [["req", "token"]],      "type" => "class"}])
  end

  it 'attributes' do
    expect(run[-1].attributes.map { |r| JSON.parse(r.to_json) })
    .to eq([{"name" => "id",              "type" => "integer", "primary_key" => true},
            {"name" => "name",            "type" => "string"},
            {"name" => "email",           "type" => "string"},
            {"name" => "credits",         "type" => "decimal", "precision" => 19, "scale" => 6, "default_value" => 6},
            {"name" => "created_at",      "type" => "datetime"},
            {"name" => "updated_at",      "type" => "datetime"},
            {"name" => "password_digest", "type" => "string"},
            {"name" => "remember_token",  "type" => "boolean"},
            {"name" => "admin",           "type" => "boolean"}])
  end

  it 'hash result' do
    result = described_class.new(schema_file: schema_file, models_dir: models_dir, logger: UnitLogger.unit).run
    expect(result.map(&:to_json)).to eq(hash_response)
  end

  let(:hash_response){
    ["{\"class_name\":\"Micropost\",\"table_name\":\"microposts\",\"attributes\":[{\"name\":\"id\",\"type\":\"integer\",\"primary_key\":true},{\"name\":\"content\",\"type\":\"string\"},{\"name\":\"user_id\",\"type\":\"integer\"},{\"name\":\"up_votes\",\"type\":\"integer\"},{\"name\":\"created_at\",\"type\":\"datetime\"},{\"name\":\"updated_at\",\"type\":\"datetime\"}],\"relationships\":[{\"name\":\"user\",\"class_name\":\"User\",\"type\":\"belongs_to\",\"foreign_key\":\"user_id\"}],\"methods\":[{\"name\":\"from_users_followed_by\",\"arguments\":[[\"opt\",\"user\"]],\"type\":\"class\"}],\"constants\":{\"MAGIC_ID\":90}}", "{\"class_name\":\"Relationship\",\"table_name\":\"relationships\",\"attributes\":[{\"name\":\"id\",\"type\":\"integer\",\"primary_key\":true},{\"name\":\"follower_id\",\"type\":\"integer\"},{\"name\":\"followed_id\",\"type\":\"integer\"},{\"name\":\"created_at\",\"type\":\"datetime\"},{\"name\":\"updated_at\",\"type\":\"datetime\"}],\"relationships\":[{\"name\":\"follower\",\"class_name\":\"User\",\"type\":\"belongs_to\",\"foreign_key\":\"follower_id\"},{\"name\":\"followed\",\"class_name\":\"User\",\"type\":\"belongs_to\",\"foreign_key\":\"followed_id\"}]}", "{\"class_name\":\"User\",\"table_name\":\"users\",\"attributes\":[{\"name\":\"id\",\"type\":\"integer\",\"primary_key\":true},{\"name\":\"name\",\"type\":\"string\"},{\"name\":\"email\",\"type\":\"string\"},{\"name\":\"credits\",\"type\":\"decimal\",\"precision\":19,\"scale\":6,\"default_value\":6},{\"name\":\"created_at\",\"type\":\"datetime\"},{\"name\":\"updated_at\",\"type\":\"datetime\"},{\"name\":\"password_digest\",\"type\":\"string\"},{\"name\":\"remember_token\",\"type\":\"boolean\"},{\"name\":\"admin\",\"type\":\"boolean\"}],\"relationships\":[{\"name\":\"microposts\",\"class_name\":\"Micropost\",\"type\":\"has_many\",\"foreign_key\":\"user_id\"},{\"name\":\"relationships\",\"class_name\":\"Relationship\",\"type\":\"has_many\",\"foreign_key\":\"follower_id\"},{\"name\":\"followed_users\",\"class_name\":\"FollowedUser\",\"type\":\"has_many\",\"foreign_key\":\"user_id\",\"through\":\"relationships\"},{\"name\":\"reverse_relationships\",\"class_name\":\"Relationship\",\"type\":\"has_many\",\"foreign_key\":\"followed_id\"},{\"name\":\"followers\",\"class_name\":\"Follower\",\"type\":\"has_many\",\"foreign_key\":\"user_id\",\"through\":\"reverse_relationships\"}],\"methods\":[{\"name\":\"feed\",\"arguments\":null,\"type\":\"instance\"},{\"name\":\"following?\",\"arguments\":[[\"req\",\"other_user\"]],\"type\":\"instance\"},{\"name\":\"follow!\",\"arguments\":[[\"req\",\"other_user\"]],\"type\":\"instance\"},{\"name\":\"unfollow!\",\"arguments\":[[\"req\",\"other_user\"]],\"type\":\"instance\"},{\"name\":\"new_remember_token\",\"arguments\":null,\"type\":\"class\"},{\"name\":\"digest\",\"arguments\":[[\"req\",\"token\"]],\"type\":\"class\"}]}"]
  }

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