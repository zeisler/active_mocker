# frozen_string_literal: true

module ActiveMocker
  class Records
    extend Forwardable
    def_delegators :records, :<<, :count, :length, :to_a

    attr_reader :records
    private :records

    def initialize(records = [])
      @records = records
    end

    def insert(record)
      records << validate_id((record.id ||= next_id), record)
    end

    def delete(record)
      raise RecordNotFound, "Record has not been created." unless records.delete(record)
    end

    def exists?(record)
      records.include?(record)
    end

    def new_record?(record)
      !exists?(record)
    end

    def persisted?(id)
      ids.include?(id)
    end

    def reset
      records.clear
    end

    private

    def ids
      records.map(&:id)
    end

    def next_id
      max_record.succ
    rescue NoMethodError
      1
    end

    def max_record
      ids.max
    end

    def validate_id(id, record)
      record.id = id.to_i
      validate_unique_id(id, record)
    end

    def validate_unique_id(id, record)
      raise IdError, "Duplicate ID found for record #{record.inspect}" if persisted?(id)
      record
    end
  end
end
