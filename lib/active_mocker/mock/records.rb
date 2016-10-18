# frozen_string_literal: true
module ActiveMocker
  class Records
    extend Forwardable
    def_delegators :records, :count, :length

    attr_reader :records
    private :records

    def initialize(records = {})
      if records.is_a?(Array)
        @records = {}
        records.each(&method(:insert))
      else
        @records = records
      end
    end

    def insert(record)
      record = validate_id((record.id ||= next_id), record)
      records.merge!(record.id => record)
    end

    alias_method :<<, :insert

    def delete(record)
      raise RecordNotFound, "Record has not been created." unless records.delete(record.id)
    end

    def exists?(record)
      records.keys.include?(record.id)
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

    alias_method :clear, :reset

    def update(record)
      records[record.id] = record
    end

    def to_a
      records.values.tap{|v| v.map(&:dup) }
    end

    def find(id)
      records[id]
    end

    private

    def ids
      records.keys
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
