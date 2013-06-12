module Unitwise
  class Scale
    attr_accessor :value, :unit_code

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
      if number.is_a?(Numeric)
        self.new(value * number, unit_code)
      elsif comparable?(other)
        self.new(value * number, "#{unit_code}.#{other.unit_code}")
      else
        raise ArgumentError
      end
    end

    def /(other)
      if number.is_a?(Numeric)
        self.new(value / number, unit_code)
      elsif comparable?(other)
        self.new(value / number, "#{unit}/#{other.unit}")
      else
        raise ArgumentError
      end
    end


  end
end