module Unitwise
  class BaseUnit < Base
    attr_accessor :names, :symbol, :primary_code, :secondary_code
    attr_accessor :property, :dim
    def self.key
      "base_unit"
    end

  end
end