class Records

  attr_reader :records

  def initialize(records=[])
    @records = records
  end

  def insert(record)
    record.attributes[:id] ||= next_id
    validate_unique_id(record)
    add_to_record_index({record.id.to_s => records.length})
    records << record
  end

  def delete(record)
    record_index.delete("#{record.id}")
    index = records.index(record)
    records.delete_at(index)
  end

  def <<(record)
    records << record
  end

  def length
    records.length
  end

  alias_method :count, :length

  def record_index
    @record_index ||= {}
  end

  def add_to_record_index(entry)
    record_index.merge!(entry)
  end

  def reset_record_index
    record_index.clear
  end

  def clear
    records.clear
  end

  def to_a
    records
  end

  def reset_all_records
    reset_record_index
    clear
  end

  def next_id
    NextId.new(records).next
  end

  def validate_unique_id(record)
    if record_index.has_key?(record.id.to_s)
      raise ActiveMock::IdError.new("Duplicate ID found for record #{record.attributes.inspect}")
    end
  end

  def exists?(record)
    if record.id.present?
      record_index[record.id.to_s].present?
    end
  end

  def new_record?(record)
    !records.include?(record)
  end

  def persisted?(id)
    records.map(&:id).include?(id)
  end

end