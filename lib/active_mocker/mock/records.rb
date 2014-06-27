module ActiveMocker
module Mock
class Records

  extend Forwardable
  def_delegators :records, :<<, :count, :length, :to_a

  attr_reader :records, :record_index
  private     :records, :record_index
  def initialize(records = [])
    @records      ||= records
    @record_index ||= {}
  end

  def insert(record)
    record.attributes[:id] ||= next_id
    validate_unique_id(record)
    add_to_record_index(record)
    records << record
  end

  def delete(record)
    raise RecordNotFound, 'Record has not been created.' if new_record?(record)
    record_index.delete("#{record.id}")
    index = records.index(record)
    records.delete_at(index)
  end

  def exists?(record)
    records.include?(record)
  end

  def new_record?(record)
    !exists?(record)
  end

  def persisted?(id)
    records.map(&:id).include?(id)
  end

  def reset
    record_index.clear
    records.clear
  end

  private

  def next_id
    NextId.new(records).next
  end

  def add_to_record_index(record)
    record_index.merge!({record.id.to_s => records.length})
  end

  def validate_unique_id(record)
    raise IdError, "Duplicate ID found for record #{record.inspect}" if record_index.has_key?(record.id.to_s)
  end

end
end
end