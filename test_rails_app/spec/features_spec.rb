require "spec_helper"
require "active_mocker/rspec_helper"
require_mock "user_mock"

describe "ActiveMocker::Features", active_mocker: true do
  describe "delete_all_before_example", order: :defined do
    context "when enabled" do
      before(:all) { active_mocker.features.enable(:delete_all_before_example) }
      after(:all) { active_mocker.features.disable(:delete_all_before_example) }
      it "test1" do
        10.times do
          User.create
        end

        expect(User.count).to eq(10)
      end

      it "test2" do
        User.create
        expect(User.count).to eq(1)
      end
    end

    context "when disabled" do
      it "test1" do
        10.times do
          User.create
        end

        expect(User.count).to eq(10)
      end

      it "test2" do
        User.create
        expect(User.count).to eq(11)
      end
    end
  end

  describe "timestamps" do
    context "when enabled" do
      before(:all) { active_mocker.features.enable(:timestamps) }
      after(:all) { active_mocker.features.disable(:timestamps) }

      it "touches updated_at and created_at" do
        record = User.create
        expect(record.updated_at).to_not be_nil
        expect(record.created_at).to_not be_nil
      end

      context "when touch is called" do
        it "increments the updated at" do
          record     = User.create
          first_time = record.updated_at
          record.touch
          expect(record.updated_at > first_time).to eq(true)
        end
      end
    end

    context "when disabled" do
      it "touches updated_at and created_at" do
        record = User.create
        expect(record.updated_at).to be_nil
        expect(record.created_at).to be_nil
      end
    end
  end

  describe "stub_active_record_exceptions", active_mocker: true do
    it "can load these exceptions" do
      ActiveRecord::RecordNotFound
      ActiveRecord::RecordNotUnique
      ActiveRecord::UnknownAttributeError
    end
  end
end
