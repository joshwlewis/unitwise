module Unitwise
  # Atoms are the most basic elements in Unitwise. They are named coded and
  # scaled units without prefixes, multipliers, exponents, etc. Examples are
  # 'meter', 'hour', 'pound force'.
  class Atom < Base
    liner :classification, :property, :metric, :special, :arbitrary, :dim
    include Compatible

    class << self
      # Array of hashes representing default atom properties.
      # @api private
      def data
        @data ||= data_files.map { |file| YAML.unsafe_load(File.open file) }.flatten
      end

      # Data files containing default atom data
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
    memoize :depth

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
    def scalar(magnitude = 1)
      base? ? magnitude : scale.scalar(magnitude)
    end

    def magnitude(scalar = scalar())
      special? ? scale.magnitude(scalar) : 1
    end

    # An atom may have a complex scale with several base atoms at various
    # depths. This method returns all of this atoms base level terms.
    # @return [Array] An array containing base Unitwise::Term
    def root_terms
      base? ? [Term.new(:atom_code => primary_code)] : scale.root_terms
    end
    memoize :root_terms


    # A basic validator for atoms. It checks for the bare minimum properties
    # and that it's scalar and magnitude can be resolved. Note that this method
    # requires the units it depends on to already exist, so it is not used
    # when loading the initial data from UCUM.
    # @return [true] returns true if the atom is valid
    # @raise [Unitwise::DefinitionError]
    def validate!
      missing_properties = %i{primary_code names scale}.select do |prop|
        val = liner_get(prop)
        val.nil? || (val.respond_to?(:empty) && val.empty?)
      end

      if !missing_properties.empty?
        missing_list = missing_properties.join(',')
        raise Unitwise::DefinitionError,
          "Atom has missing properties: #{missing_list}."
      end

      msg = "Atom definition could not be resolved. Ensure that it is a base " \
            "unit or is defined relative to existing units."

      begin
        !scalar.nil? && !magnitude.nil? || raise(Unitwise::DefinitionError, msg)
      rescue Unitwise::ExpressionError
        raise Unitwise::DefinitionError,  msg
      end
    end
  end
end
