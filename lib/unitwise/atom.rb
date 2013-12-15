module Unitwise
  class Atom < Base
    attr_accessor :classification, :property, :metric, :special, :arbitrary
    attr_writer :dim

    include Unitwise::Composable

    class << self
      def data
        @data ||= data_files.reduce([]){|m,f| m += YAML::load File.open(f)}
      end

      def data_files
        %w(base_unit derived_unit).map{|type| Unitwise.data_file type}
      end
    end

    def base?
      scale.nil? && !@dim.nil?
    end

    def derived?
      !base?
    end

    def metric?
      base? ? true : !!metric
    end

    def nonmetric?
      !metric?
    end

    def special?
      !!special
    end

    def arbitrary?
      !!arbitrary
    end

    def depth
      base? ? 0 : scale.depth + 1
    end

    def terminal?
      depth <= 3
    end

    def dim
      terminal? ? @dim || property : composition_string
    end

    def scale=(attrs)
      @scale = if attrs[:function_code]
        Functional.new(attrs[:value], attrs[:unit_code], attrs[:function_code])
      else
        Scale.new(attrs[:value], attrs[:unit_code])
      end
    end

    def scalar
      base? ? 1 : scale.scalar
    end

    def functional(x=scalar, direction=1)
      scale.functional(x, direction)
    end

    def root_terms
      base? ? [Term.new(atom: self)] : scale.root_terms
    end

    def to_s
      "#{primary_code} (#{names.join('|')})"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end