module Unitwise
  # A Measurement is a combination of a numeric value and a unit. You can think
  # of this as a type of vector where the direction is the unit designation and
  # the value is the magnitued. This is the primary class that outside code
  # will interact with. Comes with conversion, comparison, and math methods.
  class Measurement < Scale

    # Create a new Measurement
    # @param value [Numeric] The scalar value for the measurement
    # @param unit  [String, Measurement::Unit] Either a string expression, or a
    # Measurement::Unit
    # @example
    #   Unitwise::Measurement.new(20, 'm/s') # => #<Unitwise::Measurement 20 m/s>
    # @api public
    def initialize(*args)
      super(*args)
      if terms.nil?
        raise ExpressionError, "Could not evaluate `#{unit}`."
      end
    end

    # Convert this measurement to a compatible unit.
    # @param other_unit [String, Measurement::Unit] Either a string expression
    # or a Measurement::Unit
    # @example
    #   measurement1.convert_to('foot')
    #   measurement2.convert_to('kilogram')
    # @api public
    def convert_to(other_unit)
      other_unit = Unit.new(other_unit)
      if similar_to?(other_unit)
        new(converted_value(other_unit), other_unit)
      else
        raise ConversionError, "Can't convert #{inspect} to #{other_unit}."
      end
    end

    # Multiply this measurement by a number or another measurement
    # @param other [Numeric, Unitwise::Measurement]
    # @example
    #   measurent * 5
    #   measurement * some_other_measurement
    # @api public
    def *(other)
      operate(:*, other) || raise(TypeError, "Can't multiply #{inspect} by #{other}.")
    end

    # Divide this measurement by a number or another measurement
    # @param (see #*)
    # @example
    #   measurement / 2
    #   measurement / some_other_measurement
    # @api public
    def /(other)
      operate(:/, other) || raise(TypeError, "Can't divide #{inspect} by #{other}")
    end

    # Add another measurement to this unit. Units must be compatible.
    # @param other [Unitwise::Measurement]
    # @example
    #   measurement + some_other_measurement
    # @api public
    def +(other)
      combine(:+, other) || raise(TypeError, "Can't add #{other} to #{inspect}.")
    end

    # Subtract another measurement from this unit. Units must be compatible.
    # @param (see #+)
    # @example
    #   measurement - some_other_measurement
    # @api public
    def -(other)
      combine(:-, other) || raise(TypeError, "Can't subtract #{other} from #{inspect}.")
    end

    # Raise a measurement to a numeric power.
    # @param number [Numeric]
    # @example
    #   measurement ** 2
    # @api public
    def **(number)
      if number.is_a?(Numeric)
        new( value ** number, unit ** number )
      else
        raise TypeError, "Can't raise #{inspect} to #{number} power."
      end
    end

    # Coerce a numeric to a a measurement for mathematical operations
    # @param other [Numeric]
    # @example
    #   2.5 * measurement
    #   4 / measurement
    # @api public
    def coerce(other)
      case other
      when Numeric
        return self.class.new(other, '1'), self
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end

    # Convert a measurement to an Integer.
    # @example
    #   measurement.to_i # => 4
    # @api public
    def to_i
      Integer(value)
    end
    alias :to_int :to_i

    # Convert a measurement to a Float.
    # @example
    #   measurement.to_f # => 4.25
    # @api public
    def to_f
      Float(value)
    end

    # Convert a measurement to a Rational.
    # @example
    #   measurement.to_r # => (17/4)
    # @api public
    def to_r
      Rational(value)
    end

    # Will attempt to convert to a unit by method name.
    # @example
    #   measurement.to_foot # => <Unitwise::Measurement 4 foot>
    # @api semipublic
    def method_missing(meth, *args, &block)
      if args.empty? && !block_given? && (match = /\Ato_(\w+)\Z/.match(meth))
        begin
          convert_to(match[1])
        rescue ExpressionError
          super(meth, *args, &block)
        end
      else
        super(meth, *args, &block)
      end
    end

    private

    # Helper method to create a new instance from this instance
    # @api private
    def new(*args)
      self.class.new(*args)
    end

    # Determine value of the unit after conversion to another unit
    # @api private
    def converted_value(other_unit)
      if unit.special?
        if other_unit.special?
          other_unit.functional functional(value, false)
        else
          functional(value, false) / other_unit.scalar
        end
      else
        if other_unit.special?
          other_unit.functional(scalar)
        else
          scalar / other_unit.scalar
        end
      end
    end

    # Add or subtract other unit
    # @api private
    def combine(operator, other)
      if similar_to?(other)
        new(value.send(operator, other.convert_to(unit).value), unit)
      end
    end

    # Multiply or divide other unit
    # @api private
    def operate(operator, other)
      if other.is_a?(Numeric)
        new(value.send(operator, other), unit)
      elsif other.respond_to?(:composition)
        if similar_to?(other)
          converted = other.convert_to(unit)
          new(value.send(operator, converted.value), unit.send(operator, converted.unit))
        else
          new(value.send(operator, other.value), unit.send(operator, other.unit))
        end
      end
    end

  end
end