module Unitwise
  class DerivedUnit < Base
    attr_accessor :scale, :classification, :property, :metric, :special
    attr_accessor :arbitrary, :function

    def self.key
      "derived_unit"
    end

  end
end