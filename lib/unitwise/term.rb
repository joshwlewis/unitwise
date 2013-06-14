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

    def scale
      prefix.scale * (atom.scale ^ exponent)
    end

    def depth
      atom ? atom.depth + 1 : 0
    end

    def terminal?
      depth <= 4
    end

    def exponent=(number)
      @exponent = number.is_a?(Numeric) ? number : (number || 1).to_i
    end

    def exponent
      @exponent ||= 1
    end

    def root_terms
      if terminal?
        [self]
      else
        atom.measurement.root_terms.map do |t|
          Term.new(atom_code: t.atom_code, exponent: t.exponent * exponent)
        end
      end
    end

  end
end