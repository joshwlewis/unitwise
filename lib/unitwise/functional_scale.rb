module Unitwise
  class FunctionalScale < Scale

    attr_reader :function_pair

    def initialize(function_name, value, unit)
      super(value, unit)
      @function_pair = FunctionPair.find(function_name)
    end

    def forward_scale(x)
      function_pair.forward.call(x) * value * unit.scale
    end

  end
end