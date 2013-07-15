module Unitwise
  class FunctionalScale < Scale

    attr_reader :function

    def initialize(function_name, value, unit)
      super(value, unit)
      @function = Function.find(function_name)
    end

    def direct_scalar(x)
      function.direct_scalar(x) * value * unit.scalar
    end

    def inverse_scalar(x)
      function.inverse_scalar(x) * value * unit.scalar
    end

  end
end