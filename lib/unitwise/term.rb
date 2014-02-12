require 'signed_multiset'
module Unitwise
  class Term
    liner :atom_code, :prefix_code, :atom, :prefix, :factor, :exponent, :annotation

    include Unitwise::Composable

    def prefix_code
      @prefix_code ||= (@prefix.primary_code if @prefix)
    end

    def prefix
      @prefix ||= (Prefix.find(@prefix_code) if @prefix_code)
    end

    def atom_code
      @atom_code ||= (@atom.primary_code if @atom)
    end

    def atom
      @atom ||= (Atom.find(@atom_code) if @atom_code)
    end

    def special?
      atom.special rescue false
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

    def scalar
      (factor * (prefix ? prefix.scalar : 1) * (atom ? atom.scalar : 1)) ** exponent
    end

    def functional(x=scalar, forward=true)
      (factor * (prefix ? prefix.scalar : 1)) * (atom ? atom.functional(x, forward) : 1) ** exponent
    end

    def root_terms
      if terminal?
        [self]
      else
        atom.scale.root_terms.map do |t|
          self.class.new(atom: t.atom, exponent: t.exponent * exponent)
        end
      end
    end

    def to_hash
      [:prefix, :atom, :exponent, :factor, :annotation].inject({}) do |h, a|
        h[a] = send a; h
      end
    end

    def *(other)
      if other.respond_to?(:terms)
        Unit.new(other.terms << self)
      else
        Unit.new([self, other])
      end
    end

    def /(other)
      if other.respond_to?(:terms)
        Unit.new(other.terms.map{|t| t ** -1} << self)
      else
        Unit.new([self, other ** -1])
      end
    end

    def **(integer)
      self.class.new(to_hash.merge(exponent: exponent * integer))
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