module Unitwise::Standard
  class Prefix < Base

    def self.remote_key
      "prefix"
    end

    def scale
      attributes["value"].attributes["value"]
    end

    def to_hash
      super().merge(scale: scale)
    end

  end
end