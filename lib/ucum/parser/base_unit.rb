module Ucum::Parser
  class BaseUnit < Item

    def self.remote_key
      "base_unit"
    end

    def property
      attributes["property"].to_s
    end

    def dim
      attributes["@dim"]
    end

    def to_hash
      super.merge property: property, dim: dim
    end

  end
end