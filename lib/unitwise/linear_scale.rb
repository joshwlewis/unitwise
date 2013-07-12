module Unitwise
  class LinearScale < Scale

    def dup
      self.class.new(value, unit)
    end

    def scalar
      value * unit.scalar
    end

  end
end