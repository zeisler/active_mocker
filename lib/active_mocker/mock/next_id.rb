module ActiveMocker
module Mock
class NextId

  def initialize(records)
    @records = records
  end

  def next
    return 1 if max_record.nil?
    return max_record.id.succ if max_record.id.is_a?(Numeric)
    raise IdNotNumber
  end

  private

  def max_record
    @max_record ||= @records.max { |a, b| a.id <=> b.id }
  end

end
end
end