module Unitwise
  # A Term is the combination of an atom, prefix, factor and annotation.
  # Not all properties have to be present. Examples: 'g', 'mm', 'mi2', '4[pi]',
  # 'kJ{Electric Potential}'
  class Term < Liner.new(:atom, :prefix, :factor, :exponent, :annotation)
    include Compatible

    # Set the atom.
    # @param value [String, Atom] Either a string representing an Atom, or an
    # Atom
    # @api public
    def atom=(value)
      value.is_a?(Atom) ? super(value) : super(Atom.find(value.to_s))
    end

    # Set the prefix.
    # @param value [String, Prefix] Either a string representing a Prefix, or
    # a Prefix
    def prefix=(value)
      value.is_a?(Prefix) ? super(value) : super(Prefix.find(value.to_s))
    end

    # Is this term special?
    # @return [true, false]
    def special?
      atom.special? rescue false
    end

    # Determine how far away a unit is from a base unit.
    # @return [Integer]
    # @api public
    def depth
      atom ? atom.depth + 1 : 0
    end
    memoize :depth

    # Determine if this is the last term in the scale chain
    # @return [true, false]
    # @api public
    def terminal?
      depth <= 3
    end

    # The multiplication factor for this term. The default value is 1.
    # @return [Numeric]
    # @api public
    def factor
      super || 1
    end

    # The exponent for this term. The default value is 1.
    # @return [Numeric]
    # @api public
    def exponent
      super || 1
    end

    # The unitless scalar value for this term.
    # @param magnitude [Numeric] The magnitude to calculate the scalar for.
    # @return [Numeric] The unitless linear scalar value.
    # @api public
    def scalar(magnitude = 1)
      calculate(atom ? atom.scalar(magnitude) : magnitude)
    end

    # Calculate the magnitude for this term
    # @param scalar [Numeric] The scalar for which you want the magnitude
    # @return [Numeric] The magnitude on this scale.
    # @api public
    def magnitude(scalar = scalar())
      calculate(atom ? atom.magnitude(scalar) : 1)
    end

    # The base units this term is derived from
    # @return [Array] An array of Unitwise::Term
    # @api public
    def root_terms
      if terminal?
        [self]
      else
        atom.scale.root_terms.map do |t|
          self.class.new(:atom => t.atom, :exponent => t.exponent * exponent)
        end
      end
    end
    memoize :root_terms

    # Term multiplication. Multiply by a Unit, another Term, or a Numeric.
    # params other [Unit, Term, Numeric]
    # @return [Term]
    def *(other)
      operate('*', other) ||
        fail(TypeError, "Can't multiply #{ self } by #{ other }.")
    end

    # Term division. Divide by a Unit, another Term, or a Numeric.
    # params other [Unit, Term, Numeric]
    # @return [Term]
    def /(other)
      operate('/', other) ||
        fail(TypeError, "Can't divide #{ self } by #{ other }.")
    end


    # Term exponentiation. Raise a term to a numeric power.
    # params other [Numeric]
    # @return [Term]
    def **(other)
      if other.is_a?(Numeric)
        self.class.new(to_hash.merge(:exponent => exponent * other))
      else
        fail TypeError, "Can't raise #{self} to #{other}."
      end
    end

    def to_s(mode = :primary_code)
      [
        (factor if factor != 1),
        (prefix.send(mode) if prefix),
        (atom.send(mode) if atom),
        (exponent if exponent != 1)
      ].compact.join('')
    end

    private

    # @api private
    def calculate(value)
      (factor * (prefix ? prefix.scalar : 1) * value.to_s.to_r) ** exponent
    end

    # Multiply or divide a term
    # @api private
    def operate(operator, other)
      exp = operator == '/' ? -1 : 1
      if other.respond_to?(:terms)
        Unit.new(other.terms.map { |t| t ** exp } << self)
      elsif other.respond_to?(:atom)
        Unit.new([self, other ** exp])
      elsif other.is_a?(Numeric)
        self.class.new(to_hash.merge(:factor => factor.send(operator, other)))
      end
    end

  end
end
