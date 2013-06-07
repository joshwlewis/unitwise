module Unitwise
  class Term
    attr_accessor :prefix_code, :atom_code

    def initialize(attributes)
      attributes.each do |k,v|
        self.send :"#{k}=", v
      end
    end

    def prefix
      @prefix ||= Prefix.find prefix_code
    end

    def atom
      @atom ||= Atom.find atom_code
    end

    def exponent=(number)
      number ||= 1
      @exponent = number.is_a?(Numeric) ? number : number.to_i
    end

    def exponent
      @exponent ||= 1
    end

    def composition
      atom.composition || [self]
    end

  end
end