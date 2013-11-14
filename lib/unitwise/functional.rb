module Unitwise
  class Functional < Scale

    attr_reader :function

    def initialize(value, unit, function_name)
      super(value, unit)
      @function = Function.find(function_name)
    end

    def scalar
      puts "Warning: Mathematical operations with special units not reccomended by UCUM."
      super()
    end

    def functional(x=scalar, direction=1)
      function.functional(x, direction)
    end

  end
end