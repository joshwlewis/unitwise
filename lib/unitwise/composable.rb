module Unitwise
  # Composable provides methods for determing the composition of unit, term, or 
  # measurement. This is used to establish compatibility between units, terms,
  # or measurements.
  module Composable

    # @api private
    def self.included(base)
      base.send :include, Comparable
    end

    # A representation of a unit based on the atoms it's derived from.
    # @return [SignedMultiset]
    # @api public
    def composition
      root_terms.reduce(SignedMultiset.new) do |s, t|
        s.increment(t.atom.dim, t.exponent) if t.atom; s
      end
    end

    # Define a default #dim for included classes.
    # @return [String]
    # @api public
    def dim
      composition_string
    end

    # A string representation of a unit based on the atoms it's derived from
    # @return [String]
    # @api public
    def composition_string
      composition.sort.map do |k,v|
        v == 1 ? k.to_s : "#{k}#{v}"
      end.join('.')
    end

    # Determine if this instance is similar to or compatible with other
    # @return [true false]
    # @api public
    def similar_to?(other)
      self.composition == other.composition
    end

    # Compare whether the instance is greater, less than or equal to other.
    # @return [-1 0 1]
    # @api public
    def <=>(other)
      if other.respond_to?(:composition) && similar_to?(other)
        scalar <=> other.scalar
      end
    end

  end
end