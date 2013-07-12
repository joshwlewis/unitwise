module Unitwise
  class Measurement < LinearScale

    def convert(unit)
      other_unit = Unit.new(unit)
      if similar_to?(other_unit)
        self.class.new(scalar / other_unit.scalar, other_unit)
      else
        raise ConversionError, "Can't convert #{inspect} to #{other_unit}."
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
        raise TypeError, "Can't multiply #{inspect} by #{other}."
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
        raise TypeError, "Can't divide #{inspect} by #{other}"
      end
    end

    def +(other)
      if similar_to?(other)
        converted = other.convert(unit)
        self.class.new(value + converted.value, unit)
      else
        raise TypeError, "Can't add #{other} to #{inspect}."
      end
    end

    def -(other)
      if similar_to?(other)
        converted = other.convert(unit)
        self.class.new(value - converted.value, unit)
      else
        raise TypeError, "Can't subtract #{other} from #{inspect}."
      end
    end

    def **(number)
      if number.is_a?(Numeric)
        self.class.new( value ** number, unit ** number )
      else
        raise TypeError, "Can't raise #{inspect} to #{number} power."
      end
    end

    def method_missing(meth, *args, &block)
      if Unitwise::Expression.decompose(meth)
        self.convert(meth)
      else
        super(meth, *args, &block)
      end
    end

  end
end