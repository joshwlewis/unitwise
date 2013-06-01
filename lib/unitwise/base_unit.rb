module Unitwise
  class BaseUnit < Base
    attr_accessor :property, :dim
    def self.key
      "base_unit"
    end

    def metric
      true
    end

  end
end