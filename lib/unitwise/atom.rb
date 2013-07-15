module Unitwise
  class Atom < Base
    attr_accessor :classification, :property, :metric, :special
    attr_accessor :arbitrary, :dim

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
      scale.nil? && !dim.nil?
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

    def key
      base? ? dim : property
    end

    def scale=(attrs)
      @scale = if attrs[:function_code]
        FunctionalScale.new(attrs[:function_code], attrs[:value], attrs[:unit_code])
      else
        LinearScale.new(attrs[:value], attrs[:unit_code])
      end
    end

    def scalar
      base? ? 1 : scale.scalar
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