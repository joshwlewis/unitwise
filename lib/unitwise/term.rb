require 'signed_multiset'
module Unitwise
  class Term
    attr_accessor :prefix_code, :atom_code

    include Unitwise::Composable

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

    def measurement
      (prefix.measurement * atom.measurement) ^ exponent
    end

    def exponent=(number)
      @exponent = number.is_a?(Numeric) ? number : (number || 1).to_i
    end

    def exponent
      @exponent ||= 1
    end

    def root_terms
      if !atom.root?
        atom.measurement.root_terms.map do |t|
          Term.new(atom_code: t.atom_code, exponent: t.exponent * exponent)
        end
      else
        [self]
      end
    end

  end
end