module Unitwise
  class Measurement < Scale

    def initialize(value, unit)
      super(value, unit)
      if terms.nil?
        raise ExpressionError, "Could not evaluate `#{unit}`."
      end
    end

    def convert(other_unit)
      other_unit = Unit.new(other_unit)
      if similar_to?(other_unit)
        new(converted_value(other_unit), other_unit)
      else
        raise ConversionError, "Can't convert #{inspect} to #{other_unit}."
      end
    end

    def *(other)
      operate(:*, other) || raise(TypeError, "Can't multiply #{inspect} by #{other}.")
    end

    def /(other)
      operate(:/, other) || raise(TypeError, "Can't divide #{inspect} by #{other}")
    end

    def +(other)
      combine(:+, other) || raise(TypeError, "Can't add #{other} to #{inspect}.")
    end

    def -(other)
      combine(:-, other) || raise(TypeError, "Can't subtract #{other} from #{inspect}.")
    end

    def **(number)
      if number.is_a?(Numeric)
        new( value ** number, unit ** number )
      else
        raise TypeError, "Can't raise #{inspect} to #{number} power."
      end
    end

    def coerce(other)
      case other
      when Numeric
        return self.class.new(other, '1'), self
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end

    def method_missing(meth, *args, &block)
      if Unitwise::Expression.decompose(meth)
        self.convert(meth)
      else
        super(meth, *args, &block)
      end
    end

    private

    def new(*args)
      self.class.new(*args)
    end

    def converted_value(other_unit)
      if unit.special?
        if other_unit.special?
          other_unit.functional functional(value, -1)
        else
          functional(value, -1) / other_unit.scalar
        end
      else
        if other_unit.special?
          other_unit.functional(scalar)
        else
          scalar / other_unit.scalar
        end
      end
    end

    # add or subtract other unit
    def combine(operator, other)
      if similar_to?(other)
        new(value.send(operator, other.convert(unit).value), unit)
      end
    end

    # multiply or divide other unit
    def operate(operator, other)
      if other.is_a?(Numeric)
        new(value.send(operator, other), unit)
      elsif other.respond_to?(:composition)
        if similar_to?(other)
          converted = other.convert(unit)
          new(value.send(operator, converted.value), unit.send(operator, converted.unit))
        else
          new(value.send(operator, other.value), unit.send(operator, other.unit))
        end
      end
    end

  end
end