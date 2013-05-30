module Unitwise
  class BaseUnit < Base
    attr_accessor :property, :dim
    def self.key
      "base_unit"
    end

  end
end