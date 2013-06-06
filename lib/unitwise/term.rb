module Unitwise
  class Term
    attr_accessor :prefix, :atom, :exponent

    def initialize(attributes)
      attributes.each do |k,v|
        self.send :"#{k}=", v
      end
    end

  end
end