require 'signed_multiset'
module Unitwise
  class Term
    attr_accessor :prefix_code, :atom_code
    attr_writer :factor, :exponent

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
      depth <= 3
    end

    def factor
      @factor ||= 1
    end

    def exponent
      @exponent ||= 1
    end

    def scale
      (factor * (prefix ? prefix.scale : 1) * (atom ? atom.scale : 1)) ** exponent
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

    def to_s
      [(factor if factor != 1), prefix_code,
        atom_code, (exponent if exponent != 1)].compact.join('')
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end