module Unitwise
  # Atoms are the most basic elements in Unitwise. They are named coded and
  # scaled units without prefixes, multipliers, exponents, etc. Examples are
  # 'meter', 'hour', 'pound force'.
  class Atom < Base
    liner :classification, :property, :metric, :special, :arbitrary, :dim

    include Unitwise::Compatible

    class << self
      # Array of hashes representing atom properties.
      # @api private
      def data
        @data ||= data_files.map { |file| YAML.load(File.open file) }.flatten
      end

      # Data files containing atom data
      # @api private
      def data_files
        %w(base_unit derived_unit).map { |type| Unitwise.data_file type }
      end
    end

    # Determine if an atom is base level. All atoms that are not base are
    # defined directly or indirectly in reference to a base atom.
    # @return [true, false]
    # @api public
    def base?
      !!(@dim && !scale)
    end

    # Determine if an atom is derived. Derived atoms are defined with respect
    # to other atoms.
    # @return [true, false]
    # @api public
    def derived?
      !base?
    end

    # Determine if an atom is metric. Metric atoms can be combined with metric
    # prefixes.
    # @return [true, false]
    # @api public
    def metric
      base? ? true : !!@metric
    end
    alias_method :metric?, :metric

    # Determine if a unit is special. Special atoms are not defined on a
    # traditional ratio scale.
    # @return [true, false]
    # @api public
    def special
      !!@special
    end
    alias_method :special?, :special

    # Determine if a unit is arbitrary. Arbitrary atoms are not of any specific
    # dimension and have no general meaning, therefore cannot be compared with
    # any other unit.
    # @return [true, false]
    # @api public
    def arbitrary
      !!@arbitrary
    end
    alias_method :arbitrary?, :arbitrary

    # Determine how far away a unit is from a base unit.
    # @return [Integer]
    # @api public
    def depth
      base? ? 0 : scale.depth + 1
    end

    # Determine if this is the last atom in the scale chain
    # @return [true, false]
    # @api public
    def terminal?
      depth <= 3
    end

    # A representation of an atoms composition. Used to determine if two
    # different atoms are compatible.
    # @return [String]
    # @api public
    def dim
      terminal? ? @dim || property : composition_string
    end

    # Set the atom's scale. It can be set as a Scale or a Functional
    # @return [Unitwise::Functional, Unitwise::Scale]
    # @api public
    def scale=(attrs)
      @scale = if attrs[:function_code]
        Functional.new(attrs[:value], attrs[:unit_code], attrs[:function_code])
      else
        Scale.new(attrs[:value], attrs[:unit_code])
      end
    end

    # Get a numeric value that can be used to with other atoms to compare with
    # or operate on. Base units have a scalar of 1.
    # @return [Numeric]
    # @api public
    def scalar
      base? ? 1 : scale.scalar
    end

    # Get a functional value that can be used with other atoms to compare with
    # or operate on.
    # @param x [Numeric] The number to convert to or convert from
    # @param forward [true, false] Convert to or convert from
    # @return [Numeric] The converted value
    def functional(x = scalar, forward = true)
      scale.functional(x, forward)
    end

    # An atom may have a complex scale with several base atoms at various
    # depths. This method returns all of this atoms base level terms.
    # @return [Array] An array containing base Unitwise::Term
    def root_terms
      base? ? [Term.new(atom_code: primary_code)] : scale.root_terms
    end
  end
end
