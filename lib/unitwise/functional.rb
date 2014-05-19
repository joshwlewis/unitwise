module Unitwise
  # Functional is an alterative function-based scale for atoms with a
  # non-linear (or non-zero y-intercept) scale. This is most commonly used for
  # temperatures. Known functions for converting to and from special atoms
  # are setup as class methods here.
  class Functional < Scale
    extend Math

    def self.to_cel(x)
      x - 273.15
    end

    def self.from_cel(x)
      x + 273.15
    end

    def self.to_degf(x)
      9.0 * x / 5.0 - 459.67
    end

    def self.from_degf(x)
      5.0 / 9 * (x + 459.67)
    end

    def self.to_hpX(x)
      -log10(x)
    end

    def self.from_hpX(x)
      10 ** -x
    end

    def self.to_hpC(x)
      -log(x) / log(100)
    end

    def self.from_hpC(x)
      100 ** -x
    end

    def self.to_tan100(x)
      100 * tan(x)
    end

    def self.from_tan100(x)
      atan(x / 100)
    end

    def self.to_ph(x)
      to_hpX(x)
    end

    def self.from_ph(x)
      from_hpX(x)
    end

    def self.to_ld(x)
      Math.log(x) / Math.log(2)  
    end

    def self.from_ld(x)
      2 ** x
    end

    def self.to_ln(x)
      log(x)
    end

    def self.from_ln(x)
      Math::E ** x
    end

    def self.to_lg(x)
      log10(x)
    end

    def self.from_lg(x)
      10 ** x
    end

    def self.to_2lg(x)
      2 * log10(x)
    end

    def self.from_2lg(x)
      10 ** (x / 2)
    end

    attr_reader :function_name

    # Setup a new functional.
    # @param value [Numeric] The magnitude of the scale
    # @param unit [Unitwise::Unit, String] The unit of the scale
    # @param function_name [String, Symbol] One of the class methods above to be
    # used for conversion
    def initialize(value, unit, function_name)
      @function_name = function_name
      super(value, unit)
    end

    # Get the equivalent scalar value of a magnitude on this scale
    # @param magnitude [Numeric] The magnitude to find the scalar value for
    # @return [Numeric] Equivalent linear scalar value
    # @api public
    def scalar(magnitude = value)
      self.class.send(:"from_#{function_name}", magnitude)
    end

    # Get the equivalent magnitude on this scale for a scalar value
    # @param scalar [Numeric] A linear scalar value
    # @return [Numeric] The equivalent magnitude on this scale
    # @api public
    def magnitude(scalar = scalar)
      self.class.send(:"to_#{function_name}", scalar)
    end
  end
end
