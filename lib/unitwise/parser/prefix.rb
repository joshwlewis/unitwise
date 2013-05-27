module Unitwise::Parser
  class Prefix < Item

    def self.remote_key
      "prefix"
    end

    def scale
      Scale.new attributes["value"]
    end

    def to_hash
      super().merge(scale: scale)
    end

  end
end