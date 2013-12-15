module Unitwise
  module Composable

    def self.included(base)
      base.send :include, Comparable
    end

    def composition
      root_terms.reduce(SignedMultiset.new) do |s, t|
        s.increment(t.atom.dim, t.exponent) if t.atom; s
      end
    end

    def dim
      composition_string
    end

    def composition_string
      composition.sort.map do |k,v|
        v == 1 ? k.to_s : "#{k}#{v}"
      end.join('.')
    end

    def similar_to?(other)
      self.composition == other.composition
    end

    def <=>(other)
      if other.respond_to?(:composition) && similar_to?(other)
        scalar <=> other.scalar
      end
    end

  end
end