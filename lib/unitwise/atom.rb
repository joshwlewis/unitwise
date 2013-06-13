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

      def codes
        @codes ||= all.map(&:codes).flatten.sort{ |x, y| y.length <=> x.length }
      end

      def extended_codes
        @extended_codes ||= all.map(&:extended_codes).flatten.sort do |x, y|
          y.length <=> x.length
        end
      end
    end

    def additional_codes
      @additional_codes ||= (names << symbol).uniq.reject do |c|
        c.nil? || c.empty? || self.class.codes.include?(c)
      end
    end

    def extended_codes
      @extended_codes ||= codes + additional_codes
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

    def dimless?
      classification == 'dimless'
    end

    def root?
      base? || dimless?
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

    def root_terms
      measurement.root_terms unless root?
    end

  end
end