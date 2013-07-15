module Unitwise
  class LinearScale < Scale

    def dup
      self.class.new(value, unit)
    end

    def scalar
      value * unit.scalar
    end

    def direct_scalar(x)
      scalar
    end

    def inverse_scalar(x)
      scalar
    end

  end
end