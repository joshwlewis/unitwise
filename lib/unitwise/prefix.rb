module Unitwise
  class Prefix < Base
    attr_reader :scalar

    def self.data
      @data ||= YAML::load File.open(data_file)
    end

    def self.data_file
      Unitwise.data_file 'prefix'
    end

    def scalar=(value)
      @scalar = value.to_f
    end
  end
end