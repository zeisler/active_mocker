require 'spec_helper'
require 'rspec/given'
require 'bigdecimal'
require 'axiom/types'
require 'active_mocker/db_to_ruby_type'

describe ActiveMocker::DBToRubyType do

  describe '::call' do

    context 'integer' do

      Given(:db_type) { :integer }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Fixnum) }

    end

    context 'float' do

      Given(:db_type) { :float }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Float) }

    end

    context 'decimal' do

      Given(:db_type) { :decimal }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(BigDecimal) }

    end

    context 'timestamp' do

      Given(:db_type) { :timestamp }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Time) }

    end

    context 'time' do

      Given(:db_type) { :time }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Time) }

    end

    context 'datetime' do

      Given(:db_type) { :datetime }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(DateTime) }

    end

    context 'date' do

      Given(:db_type) { :date }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Date) }

    end

    context 'text' do

      Given(:db_type) { :text }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(String) }

    end

    context 'string' do

      Given(:db_type) { :string }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(String) }

    end

    context 'binary' do

      Given(:db_type) { :binary }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(String) }

    end

    context 'boolean' do

      Given(:db_type) { :boolean }

      When (:call) { described_class.call(db_type) }

      Then { expect(call).to eq(Axiom::Types::Boolean) }

    end

  end

end