module ActiveMock
class NextId

  def initialize(records)
    @records = records
  end

  def next
    return 1 if max_record.nil?
    max_record.id.succ if max_record.id.is_a?(Numeric)
  end

  def max_record
    @max_record ||= @records.max { |a, b| a.id <=> b.id }
  end

end
end