module Unitwise
  class Measurement
    attr_reader :value, :unit_code

    include Unitwise::Composable

    def initialize(value, unit_code)
      @value = value
      @unit_code = unit_code
    end

    def unit
      @unit ||= Unit.new unit_code
    end

    def root_terms
      unit.root_terms
    end

    def *(other)
      if other.is_a?(Numeric)
        self.class.new(value * other, unit_code)
      elsif compares_with?(other)
        self.class.new(value * other.value, "#{unit_code}.#{other.unit_code}")
      else
        raise ArgumentError
      end
    end

    def /(other)
      if number.is_a?(Numeric)
        self.new(value / number, unit_code)
      elsif compares_with?(other)
        self.new(value / number, "#{unit}/#{other.unit}")
      else
        raise ArgumentError
      end
    end


  end
end