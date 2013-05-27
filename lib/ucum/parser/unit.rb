module Ucum::Parser
  class Unit < Item

    def self.remote_key
      "unit"
    end

    def self.local_key
      "derived_unit"
    end

    def property
      attributes["property"].to_s
    end

    def scale
      Scale.new(attributes["value"]) unless special?
    end

    def function
      Function.new(attributes["value"]) if special?
    end

    def classification
      attributes["@class"]
    end

    def metric?
      attributes["@isMetric"] == 'yes'
    end

    def special?
      attributes["@isSpecial"] == 'yes'
    end

    def arbitrary?
      attributes["@isArbitrary"] == 'yes'
    end

    def to_hash
      hash = super()
      hash[:scale] = scale.to_hash if scale
      hash[:function] = function.to_hash if function
      hash.merge({classification: classification,
                  property: property, metric: metric?,
                  special: special?, arbitrary: arbitrary?})
    end

  end
end