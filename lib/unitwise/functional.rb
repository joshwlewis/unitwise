module Unitwise
  class Functional < Scale
    extend Math

    def self._cel(x, forward=true)
      forward ? x - 273.15 : x + 273.15
    end

    def self._degf(x, forward=true)
      forward ? 9.0 * x / 5.0 - 459.67 : 5.0 / 9 * (x + 459.67)
    end

    def self._hpX(x, forward=true)
      forward ? -log10(x) : 10 ** -x
    end

    def self._hpC(x, forward=true)
      forward ? -log(x) / log(100) : 100 ** -x 
    end

    def self._tan100(x, forward=true)
      forward ? 100 * tan(x) : atan(x / 100)
    end

    def self._ph(x, forward=true)
      _hpX(x,forward)
    end

    def self._ld(x, forward=true)
      forward ? log2(x) : 2 ** x
    end

    def self._ln(x, forward=true)
      forward ? log(x) : Math::E ** x
    end

    def self._lg(x, forward = true)
      forward ? log10(x) : 10 ** x
    end

    def self._2lg(x, forward = true)
      forward ? 2 * log10(x) : 10 ** ( x / 2 )
    end

    attr_reader :function_name

    def initialize(value, unit, function_name)
      super(value, unit)
      @function_name = function_name
    end

    def functional(x=scalar, forward = true)
      self.class.send(:"_#{function_name}", x, forward)
    end

  end
end