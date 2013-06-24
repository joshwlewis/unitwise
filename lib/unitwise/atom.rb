module Unitwise
  class Atom < Base
    attr_accessor :classification, :property, :metric, :special
    attr_accessor :arbitrary, :function, :dim

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
      measurement.nil? && !dim.nil?
    end

    def derived?
      !base?
    end

    def metric?
      base? ? true : !!metric
    end

    def special?
      !!special
    end

    def arbitrary?
      !!arbitrary
    end

    def depth
      base? ? 0 : measurement.depth + 1
    end

    def terminal?
      depth <= 3
    end

    def key
      base? ? dim : property
    end

    def measurement=(*args)
      if args.first.is_a?(Hash)
        hash = args.first
        @measurement = Measurement.new(hash[:value], hash[:unit_code])
      else
        @measurement = Measurement.new(*args)
      end
    end

    def scale
      base? ? 1 : measurement.scale
    end

    def root_terms
      base? ? [Term.new(atom: self)] : measurement.root_terms
    end

    def to_s
      "#{codes.join('|')}:#{names.join('|')}"
    end

    def inspect
      "<#{self.class} #{to_s}>"
    end

  end
end