module Unitwise
  class Number
    # Attempts to coerce a value to the simplest Numeric that fully expresses
    # it's value. For instance a value of 1.0 would return 1, a value of
    # #<BigDecimal:7f9558d559b8,'0.45E1',18(18)> would return 4.5.
    # @api public
    # @param value [Integer, Float, Rational, String, BigDecimal]
    # @return [Integer, Float, Rational, BigDecimal]
    def self.simplify(value)
      case value
      when Integer
        value
      when Float
        (i = value.to_i) == value ? i : value
      when Rational
        if (i = value.to_i) == value
          i
        elsif (f = value.to_f) && f.to_r == value
          f
        else
          value
        end
      else # String, BigDecimal, Other
        s = value.is_a?(String) ? value : value.to_s
        d = value.is_a?(BigDecimal) ? value : BigDecimal(s)
        if (i = d.to_i) == d
          i
        elsif (f = d.to_f) == d
          f
        else
          d
        end
      end
    end

    # Coerces a string-like number to a BigDecimal or Integer as appropriate
    # @api public
    # @param value Something that can be represented as a string number
    # @return [Integer, BigDecimal]
    def self.coefficify(value)
      d = BigDecimal(value.to_s)
      if (i = d.to_i) == d
        i
      else
        d
      end
    end

    # Coerce a numeric to a Rational, but avoid inaccurate conversions by
    # jruby. More details here: https://github.com/jruby/jruby/issues/4711.
    # @api public
    # @param number [Numeric]
    # @return Rational
    def self.rationalize(number)
      if number.is_a?(BigDecimal) && RUBY_PLATFORM == 'java'
        number.to_s.to_r
      else
        number.to_r
      end
    end
  end
end
