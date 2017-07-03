module Unitwise::Standard
  class Prefix < Base

    def self.remote_key
      "prefix"
    end

    def scale
      Unitwise::Number.simplify(attributes["value"].attributes["value"])
    end

    def to_hash
      super().merge(:scalar => scale)
    end

  end
end
