module ActiveMocker
  # @api private
  class DBToRubyType

    def self.call(type)
      case type
        when :integer
          Fixnum
        when :float
          Float
        when :decimal
          BigDecimal
        when :timestamp, :time
          Time
        when :datetime
          DateTime
        when :date
          Date
        when :text, :string, :binary
          String
        when :boolean
          Axiom::Types::Boolean
        when :hstore
          Hash
      end
    end

  end
end