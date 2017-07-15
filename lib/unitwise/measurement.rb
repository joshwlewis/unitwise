module Unitwise
  # A Measurement is a combination of a numeric value and a unit. You can think
  # of this as a type of vector where the direction is the unit designation and
  # the value is the magnitude. This is the primary class that outside code
  # will interact with. Comes with conversion, comparison, and math methods.
  class Measurement < Scale
    # Create a new Measurement
    # @param value [Numeric] The scalar value for the measurement
    # @param unit  [String, Measurement::Unit] Either a string expression, or a
    # Measurement::Unit
    # @example
    #   Unitwise::Measurement.new(20, 'm/s')
    # @api public
    def initialize(*args)
      super(*args)
      terms
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
      if compatible_with?(other_unit)
        new(converted_value(other_unit), other_unit)
      else
        fail ConversionError, "Can't convert #{self} to #{other_unit}."
      end
    end

    # Multiply this measurement by a number or another measurement
    # @param other [Numeric, Unitwise::Measurement]
    # @example
    #   measurent * 5
    #   measurement * some_other_measurement
    # @api public
    def *(other)
      operate(:*, other) ||
        fail(TypeError, "Can't multiply #{self} by #{other}.")
    end

    # Divide this measurement by a number or another measurement
    # @param (see #*)
    # @example
    #   measurement / 2
    #   measurement / some_other_measurement
    # @api public
    def /(other)
      operate(:/, other) || fail(TypeError, "Can't divide #{self} by #{other}")
    end

    # Add another measurement to this unit. Units must be compatible.
    # @param other [Unitwise::Measurement]
    # @example
    #   measurement + some_other_measurement
    # @api public
    def +(other)
      combine(:+, other) || fail(TypeError, "Can't add #{other} to #{self}.")
    end

    # Subtract another measurement from this unit. Units must be compatible.
    # @param (see #+)
    # @example
    #   measurement - some_other_measurement
    # @api public
    def -(other)
      combine(:-, other) ||
        fail(TypeError, "Can't subtract #{other} from #{self}.")
    end

    # Raise a measurement to a numeric power.
    # @param number [Numeric]
    # @example
    #   measurement ** 2
    # @api public
    def **(other)
      if other.is_a?(Numeric)
        new(value ** other, unit ** other)
      else
        fail TypeError, "Can't raise #{self} to #{other} power."
      end
    end

    # Round the measurement value. Delegates to the value's class.
    # @return [Integer, Float]
    # @api public
    def round(digits = nil)
      rounded_value = digits ? value.round(digits) : value.round
      self.class.new(rounded_value, unit)
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
        fail TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end

    # Convert a measurement to an Integer.
    # @example
    #   measurement.to_i # => 4
    # @api public
    def to_i
      Integer(value)
    end

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
      Number.rationalize(value)
    end

    # Will attempt to convert to a unit by method name.
    # @example
    #   measurement.to_foot # => <Unitwise::Measurement 4 foot>
    # @api semipublic
    def method_missing(meth, *args, &block)
      if args.empty? && !block_given? && (match = /\Ato_(\w+)\Z/.match(meth.to_s))
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
      if other_unit.special?
        other_unit.magnitude scalar
      else
        scalar / other_unit.scalar
      end
    end

    # Add or subtract other unit
    # @api private
    def combine(operator, other)
      if other.respond_to?(:composition) && compatible_with?(other)
        new(value.send(operator, other.convert_to(unit).value), unit)
      end
    end

    # Multiply or divide other unit
    # @api private
    def operate(operator, other)
      if other.is_a?(Numeric)
        new(value.send(operator, other), unit)
      elsif other.respond_to?(:composition)
        if compatible_with?(other)
          converted = other.convert_to(unit)
          new(value.send(operator, converted.value),
              unit.send(operator, converted.unit))
        else
          new(value.send(operator, other.value),
              unit.send(operator, other.unit))
        end
      end
    end
  end
end
