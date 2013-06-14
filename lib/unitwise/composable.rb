module Unitwise
  module Composable

    def self.included(base)
      base.send :include, Comparable
    end

    def composition
      root_terms.reduce(SignedMultiset.new) do |s, t|
        s.increment(t.atom.key, t.exponent); s
      end
    end

    def similar_to?(other)
      self.composition == other.composition
    end

    def <=>(other)
      if other.respond_to?(:composition) && similar_to?(other)
        scale <=> other.scale
      end
    end

  end
end