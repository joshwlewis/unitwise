module Unitwise
  class Measurement
    attr_reader :value

    include Unitwise::Composable

    def initialize(value, unit)
      @value = value
      if unit.is_a?(Unit)
        @unit = unit.dup
      else
        @unit = Unit.new(unit.to_s)
      end
    end

    def dup
      self.class.new(value, unit)
    end

    def unit
      @unit ||= Unit.new(@unit_code)
    end

    def root_terms
      unit.root_terms
    end

    def depth
      unit.depth + 1
    end

    def terminal?
      depth <= 3
    end

    def scale
      value * unit.scale
    end

    def convert(unit)
      other_unit = Unit.new(unit)
      if similar_to?(other_unit)
        self.class.new(scale / other_unit.scale, other_unit)
      else
        raise ArgumentError, "Can't coerce #{inspect} to #{other_unit}."
      end
    end

    def *(other)
      if other.is_a?(Numeric)
        self.class.new(value * other, unit)
      elsif other.respond_to?(:composition)
        if similar_to?(other)
          converted = other.convert(unit)
          self.class.new(value * converted.value, unit * converted.unit)
        else
          self.class.new(value * other.value, unit * other.unit)
        end
      else
        raise ArgumentError, "Can't multiply #{inspect} by #{other}."
      end
    end

    def /(other)
      if other.is_a?(Numeric)
        self.class.new(value / other, unit)
      elsif other.respond_to?(:composition)
        if similar_to?(other)
          converted = other.convert(unit)
          self.class.new(value / converted.value, unit / converted.unit)
        else
          self.class.new(value / other.value, unit / other.unit)
        end
      else
        raise ArgumentError, "Can't divide #{inspect} by #{other}"
      end
    end

    def +(other)
      if similar_to?(other)
        converted = other.convert(unit)
        self.class.new(value + converted.value, unit)
      else
        raise ArgumentError, "Can't add #{other} to #{inspect}."
      end
    end

    def -(other)
      if similar_to?(other)
        converted = other.convert(unit)
        self.class.new(value - converted.value, unit)
      else
        raise ArgumentError, "Can't subtract #{other} from #{inspect}."
      end
    end

    def **(number)
      if number.is_a?(Numeric)
        self.class.new( value ** number, unit ** number )
      else
        raise TypeError, "Numeric expected"
      end
    end

    def method_missing(meth, *args, &block)
      if Unitwise::Expression.decompose(meth)
        self.convert(meth)
      else
        super(meth, *args, &block)
      end
    end

    def to_s
      "#{value} #{unit}"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end